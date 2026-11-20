# Dotfiles

This repository contains my personal setup for MacOS machine, driven by
[mise](https://mise.jdx.dev) (`mise bootstrap`, `mise dotfiles` and tasks).

`~/.config/mise` is a symlink to [`mise/`](mise), so [`mise/config.toml`](mise/config.toml) is the global mise
config and declares the whole machine: Brewfile packages, cloned repos, symlinked dotfiles and tools.
Secrets are declared separately in [`mise/config.secrets.toml`](mise/config.secrets.toml) and only load with
`mise -E secrets`.

## Quick Start

1. Install [Homebrew](https://brew.sh) and mise:

```bash
brew install mise
```

2. Clone this repository (over HTTPS: there is no SSH key yet) and bootstrap the machine:

```bash
mise bootstrap --from https://github.com/jollopre/dotfiles.git --from-dir ~/dotfiles --config-dir mise
```

This runs `brew bundle`, clones oh-my-zsh, symlinks the dotfiles, installs the tools and sets the
Terminal.app profile. Preview any run with `--dry-run`.

3. Import the GPG keys, then bootstrap the secrets:

```bash
mise run dot:gpg:import-public-key /path/to/public-key
mise run dot:gpg:import-secret-key /path/to/secret-key
mise -E secrets bootstrap
```

This unlocks git-crypt, deploys the SSH key and the work config files, clones `pass`, and switches the
dotfiles remote to SSH.

Later runs only need `mise bootstrap` (or `mise -E secrets bootstrap`): parts already in place are left alone.

## Tasks

```
mise tasks --global
```

| Task                        | Description                                                         |
| --------------------------- | ------------------------------------------------------------------- |
| `dot:gpg:import-public-key` | Decrypt and import a GPG public key                                 |
| `dot:gpg:import-secret-key` | Decrypt and import the GPG secret key, and trust it ultimately      |
| `dot:git-crypt:unlock`      | Decrypt git-crypt files in the working tree (no-op if unlocked)     |
| `dot:git-crypt:lock`        | Re-encrypt git-crypt files (needs a clean working tree)             |
| `dot:git-crypt:status`      | List files encrypted by git-crypt                                   |
| `dot:terminal-profile`      | Install the Dracula Terminal.app profile as default (hidden)        |

## Add a dotfile

Add an entry under `[dotfiles]` in `mise/config.toml` (or `config.secrets.toml` for encrypted files) and run
`mise dot apply`. `mise dot status` shows what is out of date.

New Claude skills under `skills/` need their own entry too (one symlink per skill folder):

```toml
"~/.claude/skills/<name>" = { source = "~/dotfiles/skills/<name>" }
```

## Encrypt data

I use [git-crypt](https://github.com/AGWA/git-crypt) (GPG mode) to store secrets that otherwise would be compromised
within git versioning. Files are encrypted on commit and decrypted transparently in the working tree once unlocked.
Make sure that public/private [gpg](https://www.gnupg.org/) keys are stored in the machine beforehand.

mise does not know about git-crypt: it deploys whatever is on disk. That is why secret entries live in
`config.secrets.toml`, whose first hook unlocks the repository and stops the run if it can't.

### Unlock after cloning

```bash
mise run dot:git-crypt:unlock   # or: mise -E secrets bootstrap (unlock + deploy into $HOME)
```

### New file to be added

Add the path to `.gitattributes` **before** staging the file:

```bash
echo 'path/to/file filter=git-crypt diff=git-crypt' >> .gitattributes
git add .gitattributes path/to/file
mise run dot:git-crypt:status   # confirm it is listed as encrypted
```

### Update existing file

Once unlocked, just edit the file and commit; git-crypt encrypts it automatically.

Remember to push your changes back to this repository after updating.
