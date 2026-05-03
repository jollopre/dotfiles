---
name: open-mr
description: Push current branch to GitLab creating a merge request, then add an In Flight entry to the Obsidian MR Tracker. Use when the user says "open MR", "push and track", "create MR", "open merge request", "ship MR", or "push MR".
---

# Open MR

Push the current branch to GitLab with MR creation options, then log it in the Obsidian MR Tracker.

## Arguments

`$ARGUMENTS` is optional and may contain:
- **plan** — Obsidian note name to link as `[[Plan]]` in the tracker entry. If omitted, no plan link is added.

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

Ask the user which **label** to apply to the MR. Always ask — do not assume a default.

---

### Step 3 — Push and create MR

```bash
git push -u origin <BRANCH> \
  -o merge_request.create \
  -o merge_request.target=master \
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

### Step 4 — Add entry to Obsidian MR Tracker

Use the obsidian skill behavior rules: run `obsidian vault` to find the vault, read the tracker before editing, preserve structure.

1. Discover vault path via `obsidian vault` (parse the `path` row).
2. Locate the MR tracker by frontmatter tag `mrs` (see the vault README's *Well-known notes* section):
   ```bash
   rg -l --type md '^tags:.*\bmrs\b' "<VAULT_PATH>"
   ```
   Expect exactly one match. If zero or multiple, stop and ask the user.
3. Read the tracker file.
4. Prepend a new entry under **## In Flight**, matching the existing format exactly:

```
- [ ] **<BRANCH>** — <DESCRIPTION> | [MR !<NNNN>](<MR_URL>) | opened <YYYY-MM-DD>
```

If a **plan** argument was provided, append ` | [[<PLAN>]]` to the entry.

Where:
- `BRANCH` — the git branch name (doubles as ticket reference)
- `DESCRIPTION` — derived from the commit title, stripping the conventional commit prefix and branch tag (e.g. `tech: [PROJ-123-d] refactor auth module` becomes `Refactor auth module`). Capitalise the first word. Use the MR title's intent, not verbatim.
- `NNNN` — MR number from push output
- `MR_URL` — full GitLab MR URL from push output
- `YYYY-MM-DD` — today's date

---

### Step 5 — Report results

Print a summary:
- GitLab MR URL
- MR Tracker entry added (with or without plan link)
