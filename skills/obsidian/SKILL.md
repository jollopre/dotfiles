---
name: obsidian
description: Read, create, and update notes in the user's Obsidian vault. Use whenever the user asks to update notes, add to their vault, log an incident, track an MR, add a reference, create a calendar entry, or mentions "obsidian", "vault", "notes", "thoughts-vault". Also trigger on "note this down", "add to my notes", "update my tracker", "log this incident", "save this to my vault".
---

# Obsidian Vault

## Setup

1. Run `obsidian vault` to discover the vault path. Never hardcode it.
2. Read `README.md` in the vault root for structure and conventions.

## Behavior Rules

1. **Read before editing** — understand the file's structure first
2. **Preserve existing structure** — match heading levels, list styles, formatting
3. **Append, don't rewrite** — add to the appropriate section, don't restructure unrelated content
4. **Ask when ambiguous** — if folder or note type is unclear, ask before creating
5. **Check before creating** — prefer updating existing notes over creating duplicates
