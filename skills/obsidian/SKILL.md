---
name: obsidian
description: Read, create, and update notes in the user's Obsidian vault. Use whenever the user asks to update notes, add to their vault, log an incident, track an MR, add a reference, create a calendar entry, or mentions "obsidian", "vault", "notes". Also trigger on "note this down", "add to my notes", "update my tracker", "log this incident", "save this to my vault".
allowed-tools:
  - Bash(obsidian *)
  - Bash(ls *)
  - Read
  - Edit
---

# Obsidian Vault

## Vault Path

Always discover the vault path dynamically — never hardcode it.

- Run `obsidian vault` and use its `path` field as the absolute path to the user's vault. The command prints `name`/`path`/`files`/... lines, not just a bare path.
- Use this path as the base for any `Read`/`Edit`/`Write` operations on vault files.

## Daily Note

Always resolve today's Daily Note via the CLI — never compute the date yourself, the user's daily-note format may differ.

**Locate the real file (required workflow):**

Never rely on `obsidian daily:path` as the authoritative path — Templater's `tp.file.rename(...)` renames the file on creation, making that path stale. Always use this sequence:

1. `obsidian vault` — get the absolute vault path.
2. `ls <VAULT_PATH>/Calendar/ | grep <TODAY_DATE>` — find the real filename (e.g. `2026-05-08 - Daily.md`).
3. `Read` the file directly using its full on-disk path.

**Create today's note (when missing):**
1. If `ls` returns no match, run `obsidian daily` to trigger creation.
2. Re-run `ls` to get the actual filename after Templater renames it.
3. **Ask the user** which template to use if it's not obvious from prior daily notes — don't invent structure.
4. Carry over unchecked items (see below).

**Carry over unchecked items (on creation only):**

Run this only right after creating today's note, not every time it's opened. It applies to two sections: `## 🎯 Focus` and `## 🚀 MRs`.

1. Find the most recent daily note dated **before** today: `ls <VAULT_PATH>/Calendar/ <VAULT_PATH>/Calendar/Archive/` and pick the latest `YYYY-MM-DD - Daily.md`. Check `Archive/` too, since the previous note may already be archived (e.g. on a Monday).
2. `Read` that note. For each section, take everything from its heading up to the next `##` heading.
3. Collect every unchecked item (`- [ ]`) in its original order, together with any indented child lines under it. Skip checked items (`- [x]`), the italic description line, and the MRs template placeholder (`- [ ] Commit Subject Line | [MR !id](link) | [[Obsidian File]]`).
4. Leave out items that are already in the same section of today's note, so running this twice doesn't add duplicates. For MRs, treat two entries with the same `MR !id` as the same item.
5. `Edit` today's note to insert the items under the matching heading, after the italic description line, keeping their text exactly as it was. In MRs, if the section has only the placeholder line, replace the placeholder with the carried items instead of adding them below it (same rule as the `open-mr` skill).
6. Don't change the previous note. Its unchecked items stay as they are.
7. Handle each section on its own: if one has nothing unchecked, or the previous note doesn't have it, skip that section and say so briefly.

**Append under a specific section (required workflow):**

`daily:append` / `daily:prepend` only do whole-file ops — there is no CLI command for section-scoped insertion. Always use this sequence instead:

1. Locate the real file using the workflow above.
2. `Read` the file and locate the target heading.
3. `Edit` to insert the new content immediately under that heading, preserving existing list/formatting style.

Do not use `obsidian write` — it does not exist. Use `Edit` for targeted changes, `obsidian append` only for pure whole-file additions.

If the requested section doesn't exist in today's note, **ask the user** before creating it — the daily-note template may intentionally omit it.

## Implementation Plan

When the user asks to create an Implementation Plan note:

1. **Ask the user for the file name** — this is required, never invent it.
2. **Defaults** (use unless the user overrides):
   - `path` → `Efforts/Work`
   - `template` → `Implementation Plan`
3. Both `path` and `template` can be overridden if the user specifies a different value.
4. Before defaulting `path`, `ls <VAULT_PATH>/<default-path>/` to confirm sibling Implementation Plans live there. If the user files them elsewhere, follow that convention or ask.
5. Run: `obsidian create name="<name>" path="<path>" template="<template>"`

**Locate the real file (required workflow):**

Never trust the `Created: …` line printed by `obsidian create` — Templater may rename the file on creation (e.g. prefixing the template name), making that path stale. Always use this sequence:

1. `obsidian vault` — get the absolute vault path.
2. `ls <VAULT_PATH>/<path>/ | grep <name>` — find the real filename.
3. `Read` the file directly using its full on-disk path.

**Write into the note (required workflow):**

1. `Read` the file first to discover the template's section headings and per-task field schema.
2. Preserve those exact headings (including any emoji), field labels, and bullet style when adding content.
3. Use `Edit` for targeted insertions; do not rewrite unrelated sections.
4. If a section the user wants doesn't exist in the template, **ask before adding it** — the template may intentionally omit it.

## Archive Calendar Notes

When the user asks to archive daily notes "up to this week" (or similar — "archive everything before this week"):

1. `obsidian vault` — get the absolute vault path.
2. `ls <VAULT_PATH>/Calendar/` — list all daily notes plus the existing `Archive/` subfolder.
3. Compute the current week's Monday using ISO 8601 (weeks start **Monday**, end **Sunday**) — never assume Sunday-start. If the user's vault convention differs, ask.
4. Any daily note dated **before** that Monday is in scope. Notes dated Monday–Sunday of the current week are **not** touched, even if today is early in the week (e.g. a Tuesday leaves Monday's note alone, but the prior Sunday's note is in scope for archiving).
5. Move each in-scope file with `mv` into `Calendar/Archive/`, preserving the filename exactly.
6. Double-check the boundary date explicitly (the day before this week's Monday) — it's easy to accidentally leave it behind since it doesn't look like part of "this week" at a glance. Verify with a final `ls` on both `Calendar/` and `Calendar/Archive/` after moving.

## Behavior Rules

1. **Read before editing** — understand the file's structure first
2. **Preserve existing structure** — match heading levels, list styles, formatting
3. **Append, don't rewrite** — add to the appropriate section, don't restructure unrelated content
4. **Ask when ambiguous** — if folder or note type is unclear, ask before creating
5. **Check before creating** — prefer updating existing notes over creating duplicates
