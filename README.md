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
  gpg                   GPG
    ├── list-public-keys      List public GPG keys
    ├── list-secret-keys      List secret GPG keys
    ├── import-public-key     Import public GPG key
    ├── import-secret-key     Import secret GPG key
  git-crypt             git-crypt
    ├── unlock                Decrypt git-crypt files in the working tree
    ├── lock                  Re-encrypt git-crypt files in the working tree
    ├── status                List files encrypted by git-crypt
    ├── copy                  Unlock and setup secrets in "$HOME"
  install-pass          Install pass
  help                  Display this help message
```

3. Follow the instructions on the screen to complete the setup.

## Encrypt data

I use [git-crypt](https://github.com/AGWA/git-crypt) (GPG mode) to store secrets that otherwise would be compromised
within git versioning. Files are encrypted on commit and decrypted transparently in the working tree once unlocked.
Make sure that public/private [gpg](https://www.gnupg.org/) keys are stored in the machine beforehand.

### Unlock after cloning

```bash
./bin/setup git-crypt unlock   # or: ./bin/setup git-crypt copy (unlock + link into $HOME)
```

### New file to be added

Add the path to `.gitattributes` **before** staging the file:

```bash
echo 'path/to/file filter=git-crypt diff=git-crypt' >> .gitattributes
git add .gitattributes path/to/file
./bin/setup git-crypt status   # confirm it is listed as encrypted
```

### Update existing file

Once unlocked, just edit the file and commit; git-crypt encrypts it automatically.

Remember to push your changes back to this repository after updating.
