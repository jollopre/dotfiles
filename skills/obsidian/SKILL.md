---
name: obsidian
description: Read, create, and update notes in the user's Obsidian vault. Use whenever the user asks to update notes, add to their vault, log an incident, track an MR, add a reference, create a calendar entry, or mentions "obsidian", "vault", "notes". Also trigger on "note this down", "add to my notes", "update my tracker", "log this incident", "save this to my vault".
---

# Obsidian Vault

## Vault Path

Always discover the vault path dynamically — never hardcode it.

- Run `obsidian vault` to get the absolute path to the user's vault.
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

**Append under a specific section (required workflow):**

`daily:append` / `daily:prepend` only do whole-file ops — there is no CLI command for section-scoped insertion. Always use this sequence instead:

1. Locate the real file using the workflow above.
2. `Read` the file and locate the target heading.
3. `Edit` to insert the new content immediately under that heading, preserving existing list/formatting style.

Do not use `obsidian write` — it does not exist. Use `Edit` for targeted changes, `obsidian append` only for pure whole-file additions.

If the requested section doesn't exist in today's note, **ask the user** before creating it — the daily-note template may intentionally omit it.

## Behavior Rules

1. **Read before editing** — understand the file's structure first
2. **Preserve existing structure** — match heading levels, list styles, formatting
3. **Append, don't rewrite** — add to the appropriate section, don't restructure unrelated content
4. **Ask when ambiguous** — if folder or note type is unclear, ask before creating
5. **Check before creating** — prefer updating existing notes over creating duplicates
