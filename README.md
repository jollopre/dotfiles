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

## Encrypt files

It is used `gnupg` for encrypting/decrypting with symmetric AES cipher. For instance, in order
to encrypt a file use the following command:

```bash
gpg --symmetric --cipher-algo AES256 file.txt
```

This will create file.txt.gpg under the same directory with the passphrase typed
