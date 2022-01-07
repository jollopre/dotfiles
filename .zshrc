# Options for zsh
setopt auto_cd
cdpath=(~ ~/gitlab ~/github)

# Environment variables
export PATH="/opt/homebrew/bin:$PATH"
source ~/.tokens.sh

# oh-my-zsh setup
export ZSH=$HOME/.oh-my-zsh
ZSH_THEME="macovsky"
plugins=(git) # https://github.com/ohmyzsh/ohmyzsh/tree/master/plugins/git
source $ZSH/oh-my-zsh.sh

# rbenv initialisation
eval "$(rbenv init - zsh)"
