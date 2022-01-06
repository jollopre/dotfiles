#!/bin/bash

# Remove flywire related stuff
rm ~/.extended-routes
rm -r ~/.aws
rm ~/.tokens.sh
rm -r ~/flywire

# Remove .zshrc
rm ~/.zshrc

# Remove gitconfig
rm ~/.gitconfig

# Remove .ssh
rm -r ~/.ssh

# Uninstall vim
rm ~/.vimrc
#vim +PluginUpdate
rm -rf ~/.vim/bundle/Vundle.vim

# Uninstall ohmyzsh
rm -rf ~/.oh-my-zsh

# Uninstall pass
rm ~/.password-store
rm -rf ~/github/pass
