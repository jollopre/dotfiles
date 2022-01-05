# Dotfiles

This repository contains my personal config files. This assumes a configuration for a MacOS.

## Quick Start

Installation requires `git`.

1. Clone this repository:
```bash
git clone git@github.com:jollopre/dotfiles.git ~/dotfiles
```
2. Install applications through `brew` as well as dotfiles
```bash
sh ~/dotfiles/install.sh
```

## Encrypt data

We use [git-secret](https://git-secret.io/) to store secrets that otherwise would be compromissed
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

In order to encrypt an update file, you can modify the file as always but make sure to type:

```bash
git-secret hide
```
once is done, followed by a new commit into this repository :).
