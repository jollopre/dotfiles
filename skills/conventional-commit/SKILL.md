---
name: conventional-commit
description: Generate a commit message following the Conventional Commit specification based on the current git branch's changes against master or main. Use when the user invokes /conventional-commit or asks for a "conventional commit" message.
---

# Conventional Commit

Your task is to generate a commit message following the Conventional Commit specification based on the provided code changes for current git branch against master or main.

The commit message should follow this format:

```
<type>: [current git branch] <description>

[optional body]

flags: [SKIP_MANUAL]
```

Where `<type>` is one of the following:
- feat: A new feature
- fix: A bug fix
- docs: Documentation only changes
- chore: Changes to the build process or auxiliary tools and libraries
- tech: A technical improvement or refactor

The `[current git branch]` should be replaced with the name of the current git branch.

The `<description>` should be a concise summary of the changes made.

The optional body can provide additional context or reasoning behind the changes, explaining why they were made and their intended effect.

Please ensure the commit message is clear, concise, and adheres to the Conventional Commit guidelines. Remember the character limit per line is 72 characters.
