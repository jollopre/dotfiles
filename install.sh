#!/bin/bash

# Install Homebrew
#/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

# Install programs
brew bundle

# Create directories for git repositories
mkdir -p ~/github
mkdir -p ~/gitlab

# Reveal every secret so that it can be properly placed within the machine
git-secret reveal

# Copy flywire related stuff
cp -R flywire ~
ln -s ~/flywire/.extended-routes ~
ln -s ~/flywire/.aws ~
ln -s ~/flywire/.tokens.sh ~

# Copy .zshrc
cp .zshrc ~

# Copy gitconfig
cp .gitconfig ~

# Copy .ssh
cp -R .ssh ~
chmod 0600 ~/.ssh/id_rsa

# Install vim
cp .vimrc ~
cp -R skeletons ~
rm -rf ~/.vim/bundle/Vundle.vim
git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim
vim +PluginInstall +qall

# Install ohmyzsh
rm -rf ~/.oh-my-zsh
git clone https://github.com/ohmyzsh/ohmyzsh.git ~/.oh-my-zsh

# Install pass from my personal git repository
rm -rf ~/github/pass
git clone git@github.com:jollopre/pass.git ~/github/pass
ln -s ~/github/pass ~/.password-store
