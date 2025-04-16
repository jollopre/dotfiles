# Options for zsh
setopt auto_cd
cdpath=(~ ~/gitlab ~/github)

# Environment variables
HOMEBREW_PATH=/opt/homebrew/bin
RUBY_PATH=/opt/homebrew/opt/ruby/bin
RUBY_GEMS_PATH=/opt/homebrew/lib/ruby/gems/$(/opt/homebrew/opt/ruby/bin/ruby -e 'puts RbConfig::CONFIG["ruby_version"]')/bin
export PATH="$RUBY_GEMS_PATH:$HOMEBREW_PATH:$RUBY_PATH:$PATH"
source ~/.tokens.sh

# oh-my-zsh setup
export ZSH=$HOME/.oh-my-zsh
ZSH_THEME="macovsky"
plugins=(git) # https://github.com/ohmyzsh/ohmyzsh/tree/master/plugins/git
source $ZSH/oh-my-zsh.sh
