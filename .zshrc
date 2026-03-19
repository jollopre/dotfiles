# Options for zsh
setopt auto_cd
cdpath=(~ ~/gitlab ~/github)

export RUBY_PATH="/opt/homebrew/opt/ruby/bin"
export RUBY_GEMS_PATH="$($RUBY_PATH/ruby -e 'print Gem.bindir')"
export PATH="$HOME/.local/bin:$RUBY_GEMS_PATH:$RUBY_PATH:$PATH"

source ~/.tokens.sh
source ~/.aliases.sh

# oh-my-zsh setup
export ZSH=$HOME/.oh-my-zsh
ZSH_THEME="macovsky"
plugins=(git) # https://github.com/ohmyzsh/ohmyzsh/tree/master/plugins/git
source $ZSH/oh-my-zsh.sh
