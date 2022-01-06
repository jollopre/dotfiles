# Dotfiles

This repository contains my personal config files. This assumes a configuration for a MacOS.

## Quick Start

Installation requires [git](https://git-scm.com/) and [gpg](https://gnupg.org/).

1. Clone this repository:
```bash
git clone git@github.com:jollopre/dotfiles.git ~/dotfiles
```

2. Import public and private gpg keys from the backup in place:
```
# Decrypt the keys using the memorable passphrase
gpg -o private.key -d private.key.gpg
gpg -o public.key -d public.key.gpg

# Import the keys into gpg
gpg --allow-secret-key-import --import private.key
gpg --import public.key

# Check keys are properly imported
gpg --list-secret-keys
gpg --list-keys
```

3. Run install script
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

In order to encrypt an updated file, you can modify the file as always but make sure to type:

```bash
git-secret hide
```
and remember, once you are done, please push changes back to this repository :).

## Backup gpg keys

1. Export keys from gpg:
```bash
gpg --export-secret-keys <key_id> > private.key
gpg --export <key_id> > public.key
```

2. Encrypt them with a passphrase, remember to use something memorable:
```bash
gpg --symmetric --cipher-algo AES256 private.key
gpg --symmetric --cipher-algo AES256 public.key
```

3. Store the encrypted keys into a safe place, remember the files ending with `.gpg` ONLY.
