setopt auto_cd
cdpath=(~ ~/gitlab ~/github)

export PATH="$HOME/.local/bin:$PATH"

# Rancher Desktop CLI tools (docker, kubectl, nerdctl...) when installed
[[ -d "$HOME/.rd/bin" ]] && export PATH="$HOME/.rd/bin:$PATH"

source ~/.aliases.sh

summarize() {
  claude -p "/summarise $*" --allowedTools 'WebFetch,Read'
}

export ZSH=$HOME/.oh-my-zsh
ZSH_THEME="macovsky"
plugins=(git)
source $ZSH/oh-my-zsh.sh

# Must run after PATH changes so mise's shims take precedence
eval "$(mise activate zsh)"
