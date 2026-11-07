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

### Step 3 — Push and create MR

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

### Step 4 — Add entry to today's Daily Note

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

### Step 5 — Report results

Print a summary:
- GitLab MR URL
- Target branch. If it isn't `master`, say the MR is stacked on that branch and that it must be retargeted to `master` once the base MR merges (GitLab does this automatically when the base branch is deleted on merge).
- Daily note entry added (with or without Obsidian file link)
