# Dotfiles

This repository contains my personal setup for MacOS machine.

## Quick Start

1. Clone this repository:

```bash
git clone git@github.com:jollopre/dotfiles.git ~/dotfiles
```

2. Import public and private gpg keys from the backup store:

```
./installer gpg --import-secret-key=/a/path/to/private.key.gpg
./installer gpg --import-public-key=/a/path/to/public.key.gpg

# Check keys are properly imported

./installer gpg --list-secret-keys
./installer gpg --list-public-keys
```

3. Run installer

```bash
# Run brew bundle to install cask/brew programs
./installer install
# Copy decrypted secret files into ~
./installer copy-secrets
# Copy dotfiles
./installer copy-dotfiles
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

In order to encrypt an updated file, you can modify the file as always but make sure to type:

```bash
git-secret hide
```
and remember, once you are done, please push changes back to this repository :).
