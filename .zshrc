# Options for zsh
setopt auto_cd
cdpath=(~ ~/gitlab ~/github)

# Environment variables
HOMEBREW_PATH=/opt/homebrew/bin
RUBY_PATH=/opt/homebrew/opt/ruby/bin
RUBY_GEMS_PATH=/opt/homebrew/lib/ruby/gems/$($RUBY_PATH/ruby -e 'puts RbConfig::CONFIG["ruby_version"]')/bin
export PATH="$RUBY_GEMS_PATH:$HOMEBREW_PATH:$RUBY_PATH:$PATH"
source ~/.tokens.sh

# oh-my-zsh setup
export ZSH=$HOME/.oh-my-zsh
ZSH_THEME="macovsky"
plugins=(git) # https://github.com/ohmyzsh/ohmyzsh/tree/master/plugins/git
source $ZSH/oh-my-zsh.sh

# Aliases
alias aws-sso='aws sso login --profile sso_platform_pro_dev && aws ecr get-login-password --region us-east-1 --profile sso_platform_sta_dev | docker login --username AWS --password-stdin 339713173028.dkr.ecr.us-east-1.amazonaws.com'
