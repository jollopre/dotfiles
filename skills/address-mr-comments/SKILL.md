---
name: address-mr-comments
description: Work through the review comments on a GitLab merge request one at a time — enumerate them, check each claim against the code, fix or reply, and resolve only with the user's approval. Use when the user says "address the comments", "assess the MR comments", "go through the review", "handle the review notes/nits", or passes an MR URL or !id asking to deal with its feedback.
allowed-tools:
  - Bash(glab *)
  - Bash(git *)
  - Bash(jq *)
  - Bash(lsof -nP -iTCP:8888 -sTCP:LISTEN)
  - Read
  - Edit
  - Write
---

# Address MR Comments

Work through the review comments on a merge request one item at a time. The user decides the verdict, the order, and every message posted to GitLab.

## Arguments

`$ARGUMENTS` is the MR URL or its `!id`. If it's missing, use the MR for the current branch: `glab mr view -F json | jq .iid`.

## GitLab access

Use `glab` only. Run it inside the repo clone, where `:id` resolves to the project from the git remote. If `:id` fails (for example when the remote uses an SSH host alias), use the URL-encoded project path instead, such as `projects/group%2Fsubgroup%2Fproject/...`.

The GitLab instance sits behind an access proxy, so API calls must go through a local tunnel. The `glab` shell wrapper in `~/.aliases.sh` sends them there, and the glab config adds the auth header. If a call fails with `invalid character '<'` (an HTML login page instead of JSON), the request didn't go through the tunnel. Check that the tunnel is running, that the GitLab token hasn't expired, and that `glab` resolves to the wrapper (`type glab`).

| Action | Command |
|---|---|
| List discussions | `glab api "projects/:id/merge_requests/<IID>/discussions?per_page=20&page=<N>"` |
| Reply in a thread | `glab api -X POST "projects/:id/merge_requests/<IID>/discussions/<DID>/notes" -f body="$(cat <<'EOF' … EOF)"` |
| Resolve a thread | `glab api -X PUT "projects/:id/merge_requests/<IID>/discussions/<DID>" -f resolved=true` |
| Delete a note | `glab api -X DELETE "projects/:id/merge_requests/<IID>/discussions/<DID>/notes/<NID>"` |
| Read the MR description | `glab mr view <IID> -F json \| jq -r .description` |
| Update the MR description | `glab mr update <IID> --description "$(cat <<'EOF' … EOF)"` |

Always pass multi-line bodies through a quoted heredoc.

Page through discussions in small pages: `per_page=100` can return HTTP 502 while other endpoints work. Fetch pages until one comes back shorter than `per_page`. If a call fails, probe a lighter endpoint (`glab api "projects/<P>/merge_requests/<IID>"`) to tell a GitLab outage from a failing endpoint.

## Workflow

Do the steps in order. Stop after each step marked **(wait)** until the user answers.

### 0. Check the tunnel

Before any `glab` call, check that `cloudflared-proxy` is listening on the port the `glab` wrapper uses: `lsof -nP -iTCP:8888 -sTCP:LISTEN`. If nothing is listening, stop and tell the user the tunnel isn't running and that they can start it with `cloudflared-proxy run`. Don't start, restart or work around it yourself. Wait until the user says it's up, then check again.

### 1. Fetch

List the discussions. Drop system notes (`.notes[0].system == true`) and threads that are already resolved. For each remaining thread, record:
- the discussion id and note ids
- the author
- the file and line (`position.new_path` and `position.new_line`), or "general"
- whether it can be resolved (`resolvable`)
- the body

Bot summary notes (for example from `bot_reviewer`) often hold several nitpicks and suggestions in one general note. Split them into separate items, keeping the bot's IDs (`NIT-1`, …). Check `resolvable` on each fetch: a summary note can start out unresolvable and become resolvable later, for example after a reply.

**A bot reviews again after each push**, editing its summary note in place. So when this skill runs on an MR that was already reviewed, new items can sit inside the existing summary note, marked "new since previous review", not only in new threads. Take items from the summary body as well as the thread list. Skip the ones its "Resolved" section lists and the ones that already have a reply.

### 2. Enumerate (wait)

**Check each claim against the code before giving a verdict.** Read the file and line it points to, and the docs it cites. Bots are often half right: they get a symptom right but its consequence wrong, or they cite a rule the repo doesn't follow. In particular:

- **Trace each consequence to its entry point.** For every "X fails" or "returns 500" claim, find where the code path starts: an HTTP endpoint, a background job, or code that rescues the error. Cite the line. A rescued error or a job failure isn't a 500.
- **Check whether it's a regression.** Compare with the MR's base commit (`git show <base>:<file>`). If the same input already failed before, it isn't caused by this change. To date code the MR only moved or renamed, use `git log -S'<snippet>'`.
- **Read the cited doc section itself.** A bot can cite a real section for a rule it doesn't state, such as a doc that explains how to write a backfill cited as requiring one.
- **When a validation rule gets stricter, map the stored data.** List every table that persists the affected field, and how each row is read back: through the validation, around it, or for display only. The gaps are usually in the paths that rebuild stored input without validating it again.

Show one table, ordered by severity: **Critical, then High, then Medium, then Low, then Nit, then suggestions**.

| # | Where | What it says | Verdict | Proposed action |

- **Verdicts:** valid, partly valid, reject, or out of scope. Give one line of evidence for each, such as a file and line, a doc line or a spec.
- **Proposed actions:** a code fix, a reply only, a change to the MR description, or a follow-up. When an item is out of scope but cheap to fix in this MR, especially a spec-only change, offer both the fix and the follow-up, and let the user choose.

Then propose an order (by severity unless the user says otherwise) and wait. If there is only one item, skip the order and just ask whether to go ahead.

### 3. Go through the items one at a time (wait after each)

For each item, in the order the user chose:

1. **Show the item in full.** Quote the comment verbatim, whatever its severity, followed by where it points, the verdict, the evidence and the proposed action. The user shouldn't have to scroll back to the table. Show only this item, not the ones still to come.
2. **Assess it.** Say what you'd change or reply.
3. **Fix the code, if the item needs it.**
   - Follow strict TDD: write a failing spec first, then the smallest code change.
   - A spec that passes as soon as it's written must still be shown to fail. That covers a spec added after the fix, or one that records existing behaviour. Run it with the fix stashed, or with an input it must reject, and report both runs.
   - With the fix, list each path that reaches the changed code (for example the validation, the HTTP request, stored data read back) and whether a spec covers it, so the user doesn't have to ask.
   - Follow the repo's own conventions. Read its `CLAUDE.md` and the docs that cover the code.
   - Run the targeted specs and the linter, then show `git diff`.
4. **Draft the reply.** Skip this for items from a summary note (see step 5). Post it only when the user has approved that exact text, then **quote the reply as posted**. If the user approves but changes what the reply must say (for example, "track it in MR 5 instead"), show the revised draft and wait again. Post right away only if the approved draft goes out unchanged. A reply about a local fix that isn't pushed yet should say it comes in the next push.
5. **Resolve** only when the user says so.
6. **Point to the next item.** End the turn by showing the next unresolved item in full, as in step 1, and ask whether to go ahead.

If the user corrects a fact (for example who consumes an event), re-check every reply, commit message, MR description and plan that repeats the wrong fact. List them and offer to fix each one. Do the same when one of your own fixes makes a sentence wrong. For example, if a fix tightens validation, a commit message saying "the validation already covers this" is now false.

### 4. Fix a reply that was wrong

If a posted reply turns out to be wrong, offer two options and let the user pick:
- **Replace it:** delete the note, then post the corrected reply. The delete can't be undone.
- **Add a correction:** post a follow-up reply that starts with "Correction:".

Before deleting, fetch the thread and check that the note id belongs to the user's reply, not to the reviewer's note.

### 5. Items from a summary note

Items split out of a summary note (nitpicks, suggestions) have no thread of their own, so don't draft or post a reply for them, and skip the reply and resolve steps (4 and 5) in step 3. Settle each one locally (fix, follow-up or no change) and list the outcome in the final report. Post on the summary note only if the user asks for it.

### 6. Finish (wait before each external action)

If the review changed no code, skip the commit, the push and the MR description update. Still check that the commit message and the MR description don't repeat a fact the review proved wrong.

1. **Commit:** run the repo's full linter and test suite first, not just the targeted specs. On a single-commit feature branch, amend the commit. Update its message if a fact in it changed. Otherwise add a new commit. Push with `git push --force-with-lease`, never a plain `--force`.
2. **MR description:** read the current description first. GitLab fills it from the first commit, so it can still contain claims that are now wrong. Show the replacement, and end it with the attribution lines the session requires.
3. **Report:**
   - the threads resolved
   - the threads still open, and what each is waiting on
   - the commit SHA that was pushed, or "nothing pushed, branch unchanged at `<sha>`"
   - follow-ups that were deferred
4. **Memory:** save any non-obvious domain fact you learned during the review to memory, such as a consumer's routing-key binding.

## Guardrails

- Nothing goes to GitLab — a reply, resolve, delete, description change or push — without the user's approval for that step. A GitLab post is visible to the whole team.
- Never fix docs under `docs/` and a skill together. If a doc change makes a skill out of date, flag it as drift instead.
- Bot advice about skills and unrelated refactors are listed as follow-ups, not made in the MR. For other out-of-scope items, the user decides between a fix in the MR and a follow-up (see step 2).
- Don't count "the bot said so" as evidence. Every verdict needs a code, doc or spec reference.
- Never weaken a test, add `# standard:disable`, or skip hooks to make a reviewer's request pass.
