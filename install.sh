#!/bin/bash

# Install Homebrew
#/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

# Install programs
brew bundle

# Copy flywire related stuff
cp -R flywire ~
gpg -o ~/flywire/.extended-routes -d ~/flywire/.extended-routes.gpg
ln -s ~/flywire/.extended-routes ~
gpg -o ~/flywire/.aws/config -d ~/flywire/.aws/config.gpg
ln -s ~/flywire/.aws ~
gpg -o ~/flywire/tokens.sh -d ~/flywire/tokens.sh.gpg
ln -s ~/flywire/tokens.sh ~

# Copy .zshrc
cp .zshrc ~

# Copy gitconfig
cp .gitconfig ~

# Install vim
cp .vimrc ~
git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim
vim +PluginInstall +qall

# Install ohmyzsh
git clone https://github.com/ohmyzsh/ohmyzsh.git ~/.oh-my-zsh
