homebrew_flag=${args[--homebrew]}
ohmyzsh_flag=${args[--ohmyzsh]}
pass_flag=${args[--pass]}
vim_flag=${args[--vim]}
tmux_flag=${args[--tmux]}

if [[ $homebrew_flag ]]; then
  echo "installing homebrew with --homebrew"
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi

if [[ $ohmyzsh_flag ]]; then
  echo "installing ohmyzsh with --ohmyzsh"
  rm -rf ~/.oh-my-zsh
  git clone https://github.com/ohmyzsh/ohmyzsh.git ~/.oh-my-zsh
fi

if [[ $pass_flag ]]; then
  echo "installing pass with --pass"
  rm -rf ~/github/pass
  git clone git@github.com:jollopre/pass.git ~/github/pass
  ln -s -f ~/github/pass ~/.password-store
fi

if [[ $vim_flag ]]; then
  echo "installing vim with --vim"
  if [[ -e ~/.vimrc ]]; then
    cp -R skeletons ~
    rm -rf ~/.vim/bundle/Vundle.vim
    git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim
    vim +PluginInstall +qall
  else
    echo "file .vimrc does not exist under ~, nothing will be installed"
  fi
fi

if [[ $tmux_flag ]]; then
  echo "installing tmux with --tmux"
  if [[ -e ~/.tmux.conf ]]; then
    rm -rf ~/.tmux/plugins/tpm
    git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
  else
    echo "file .tmux.conf does not exist under ~, nothing will be installed"
  fi
fi

echo "Install or update according to Brewfile"
brew bundle
