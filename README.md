# Dotfiles

This repository contains my personal setup for MacOS machine.

## Quick Start

1. Clone this repository:

```bash
git clone git@github.com:jollopre/dotfiles.git ~/dotfiles
```

2. Run setup

```bash
./bin/setup
```

will display a menu with the following options:

```
Usage: bin/setup <command> [subcommand]
Commands:
  config-git            Configure git
  install-ohmyzsh       Install OhMyZSH
  install-homebrew      Install homebrew
  install-neovim        Install neovim
  install-tmux          Install tmux
  gpg                   GPG
    ├── list-public-keys      List public GPG keys
    ├── list-secret-keys      List secret GPG keys
    ├── import-public-key     Import public GPG key
    ├── import-secret-key     Import secret GPG key
  git-secret            git-secret
    ├── add                   Add file for encrypting (TODO)
    ├── update                Update file for encrypting (TODO)
    ├── copy                  Copy secrets to "/Users/Jose.Lloret" (TODO, decouple .ssh from this flow)
  install-pass          Install pass
  help                  Display this help message
```

3. Follow the instructions on the screen to complete the setup.

## Encrypt data

I use [git-secret](https://git-secret.io/) to store secrets that otherwise would be compromised
within git versioning. Make sure that public/private [gpg](https://www.gnupg.org/) keys are stored in the machine beforehand.

### New file to be added

In order to add a new file for encrypting, you can type the following:

```bash
# Add file to the index of files tracked to be encrypted
git-secret add <filename>
# Encrypts all the files that have been added
git-secret hide
```

### Update existing file

In order to encrypt an updated file, you can modify the file as always but make sure to type:

```bash
git-secret hide
```
and remember, once you are done, please push changes back to this repository :).
