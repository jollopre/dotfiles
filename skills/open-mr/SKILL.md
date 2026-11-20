---
name: open-mr
description: Push current branch to GitLab creating a merge request (derived from the commit title), then log it under the MRs section of today's Obsidian Daily Note. Use when the user says "open MR", "push and track", "create MR", "open merge request", "ship MR", or "push MR".
allowed-tools:
  - Bash(git *)
  - Bash(obsidian *)
  - Bash(ls *)
  - Read
  - Edit
---

# Open MR

Push the current branch to GitLab with MR creation options, then log it under the **🚀 MRs** section of today's Obsidian Daily Note.

## Arguments

`$ARGUMENTS` is optional and may contain:
- **obsidian-file** — Obsidian note name to link as `[[Obsidian File]]` in the daily-note entry. If omitted, the entry is added without an Obsidian file link.

Examples:
```
/open-mr
/open-mr Refactor Auth Module
```

## Workflow

Execute steps in order. Stop and report if any step fails.

---

### Step 1 — Validate preconditions

```bash
git rev-parse --git-dir        # must be a git repo
git branch --show-current       # must not be master/main
```

If on `master` or `main`, warn the user and stop.

Verify there are commits ahead of master:
```bash
git log origin/master..HEAD --oneline
```

If no commits, tell the user there is nothing to push and stop.

---

### Step 2 — Gather push parameters

Extract from git state:
- **branch**: current branch name (`git branch --show-current`)
- **title**: first line of the latest commit (`git log -1 --format='%s' HEAD`)
- **assignee**: user's email from memory or git config (`git config user.email`)
- **target**: the branch this one was cut from (see below)

#### Detect the target branch

When the branch was cut from another unmerged branch, open a stacked MR against that branch so the diff shows only this branch's commits. Detect it automatically:

```bash
git fetch -q origin
git for-each-ref --format='%(refname:short)' refs/remotes/origin \
  --merged HEAD --no-merged origin/master \
  | grep -vx -e origin/HEAD -e "origin/<BRANCH>"
```

This lists remote branches whose tip is in this branch's history but not yet merged to master.

- **No candidates** → target is `master`.
- **One candidate** → target is that branch (strip the `origin/` prefix).
- **Several candidates** → pick the closest one, the one with the fewest commits up to `HEAD` (`git rev-list --count origin/<candidate>..HEAD`). Use it as the target.

Ask the user which **label** to apply to the MR. Always ask — do not assume a default, and do not infer one from the repo, ticket prefix, past MRs, or memory. Only skip the question when the user has explicitly named the label in the current request.

---

### Step 3 — Comprehension check

Before pushing, quiz the user on the changes to confirm they understand them well enough to ship.

Read the full diff against the target:
```bash
git diff --stat origin/<TARGET>...HEAD
git diff origin/<TARGET>...HEAD
```

Decide how many questions to ask, **between 3 and 5**:
- **3** for small, low-risk changes (config tweaks, renames, docs, isolated fixes).
- **4–5** for larger diffs or changes touching critical paths: payments, auth, data migrations, concurrency, external integrations, security-sensitive code, or performance-sensitive code.

Build the questions from the actual diff. Cover the dimensions that matter most for this change:
- **Edge cases**: empty/nil inputs, boundaries, retries, partial failures, ordering.
- **What could break**: callers, backwards compatibility, rollout and rollback, data already in production.
- **Security**: input validation, authorization, secrets, injection, sensitive data in logs.
- **Performance**: N+1 queries, unbounded loops or loads, locking, hot paths.
- **Pattern used**: why this approach over the alternatives, and what it trades off.

Rules:
- Ask **one question at a time** and wait for the answer before asking the next. Never batch them.
- Ground each question in a behaviour the diff changes. No generic trivia. Name the change (a file or a flow), not the method or line that holds the answer: finding it is part of the reasoning.
- Don't hint at the answer in the question:
  - Don't presuppose the conclusion. "What would go wrong if X and Y were swapped?", "Which inputs reach the span unmasked?" and "What keeps callers from running X?" each say there is a problem and where it is. Ask "Does the order of X and Y matter?", "What ends up on the span for a PAN?", "Can existing callers reach the new steps?".
  - Don't name the edge case, scenario or failure mode you want the user to find (e.g. "suppose no span is open"). Describe the change and ask what could break or what it affects.
  - Don't point at the helper whose code gives the answer away (e.g. "look at `mask_value`").
  - Before asking, reread the question. If it names where the answer is, assumes a problem exists, or narrows to the one case that matters, rewrite it.
- Code references belong in the feedback after the answer, not in the question.
- After each answer, give brief feedback. If it's correct, say so. If it's incomplete or wrong, explain the gap and point to the relevant code, then move on.
- After the last question, summarise any gaps found and ask whether to proceed with the push, or stop so the user can address them. Only continue to Step 4 on explicit confirmation.

---

### Step 4 — Push and create MR

```bash
git push -u origin <BRANCH> \
  -o merge_request.create \
  -o merge_request.target=<TARGET> \
  -o "merge_request.label=<LABEL>" \
  -o "merge_request.title=<TITLE>" \
  -o "merge_request.assignee=<ASSIGNEE>"
```

Parse the MR URL and MR number (`!NNNN`) from the git push output. The remote prints a line like:
```
remote: View merge request for BRANCH:
remote:   https://$GITLAB_HOST/.../merge_requests/NNNN
```

---

### Step 5 — Add entry to today's Daily Note

Delegate to the `obsidian` skill's Daily Note workflow to locate and edit today's note. Append a new entry under the **## 🚀 MRs** heading using the format:

```
- [ ] <DESCRIPTION> | [MR !<NNNN>](<MR_URL>) | [[<OBSIDIAN_FILE>]]
```

If the **obsidian-file** argument was omitted, drop the trailing ` | [[<OBSIDIAN_FILE>]]` segment.

If the section contains only the placeholder template line (e.g. `- [ ] Commit Subject Line | [MR !id](link) | [[Obsidian File]]`), replace that placeholder with the real entry instead of appending below it.

Where:
- `DESCRIPTION` — the commit title verbatim. Do not strip the conventional commit prefix, ticket references, or any other part — preserve it exactly as-is.
- `NNNN` — MR number from push output
- `MR_URL` — full GitLab MR URL from push output
- `OBSIDIAN_FILE` — the value of the optional `obsidian-file` argument

If the **## 🚀 MRs** heading is missing from today's note, stop and ask the user before creating it — the daily-note template may intentionally omit it.

---

### Step 6 — Report results

Print a summary:
- GitLab MR URL
- Target branch. If it isn't `master`, say the MR is stacked on that branch and that it must be retargeted to `master` once the base MR merges (GitLab does this automatically when the base branch is deleted on merge).
- Daily note entry added (with or without Obsidian file link)
