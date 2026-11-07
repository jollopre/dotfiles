# Options for zsh
setopt auto_cd
cdpath=(~ ~/gitlab ~/github)

export PATH="$HOME/.local/bin:$PATH"

# Rancher Desktop CLI tools (docker, kubectl, nerdctl...) when installed
[[ -d "$HOME/.rd/bin" ]] && export PATH="$HOME/.rd/bin:$PATH"

source ~/.aliases.sh

# oh-my-zsh setup
export ZSH=$HOME/.oh-my-zsh
ZSH_THEME="macovsky"
plugins=(git) # https://github.com/ohmyzsh/ohmyzsh/tree/master/plugins/git
source $ZSH/oh-my-zsh.sh

# mise: activate tool version manager (keep after PATH setup)
eval "$(mise activate zsh)"
