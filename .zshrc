export PYENV_ROOT="$HOME/.pyenv"
[[ -d $PYENV_ROOT/bin ]] && export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init - zsh)"

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

# Kubernetes aliases
alias kubectl='kubecolor'
alias k='kubectl'
alias kgp='kubectl get pods'
alias kgpa='kubectl get pods -A'
alias kgpw='kubectl get pods -o wide'
alias kgpwch='kubectl get pods --watch -o wide'
alias kap='kubectl apply -f'
alias kdel='kubectl delete -f'
alias krep='kubectl replace -f'
alias kroll='kubectl rollout'
alias kex='kubectl exec -it'
kdp() {
  local line
  line=$(kgpa | fzf --preview="kubectl describe pod {2} -n {1}")
  [[ -n "$line" ]] && kubectl describe pod $(echo "$line" | awk '{print $2}') -n $(echo "$line" | awk '{print $1}')
}
alias kgl='kubectl get logs'
kpl() {
  local namespace
  local pod
  namespace=$(kubectl get namespace -o name | awk -F '\/' '{print $2}' | fzf)
  pod=$(kgp -o name --namespace $namespace | fzf)
  k logs $pod --namespace $namespace
}
alias kgs='kubectl get svc'
alias kgd='kubectl get deployments'
alias kgn='kubectl get nodes'
alias kgctx='kubectl config get-contexts'
alias kctx='kubectl config use-context'
alias kgns='kubectl get namespaces'
alias kns='kubectl config set-context --current --namespace'

# Git aliases and functions
alias s='git status -sb'
alias ga='git add -A'
alias gbr='git branch -v'

gc() {
  git diff --cached | grep '\btap[ph]\b' >/dev/null &&
    echo "\e[0;31;29mOops, there's a #tapp or similar in that diff.\e[0m" ||
    git commit -v "$@"
}

alias gcm='git commit -v --amend'
alias gco='git checkout'

alias gd='git diff -M'
alias gd.='git diff -M --color-words="."'
alias gdc='git diff --cached -M'
alias gdc.='git diff --cached -M --color-words="."'

# Helper function.
git_current_branch() {
  cat "$(git rev-parse --git-dir 2>/dev/null)/HEAD" | sed -e 's/^.*refs\/heads\///'
}

alias gll='git log --oneline'
alias glog='git log --date-order --pretty="format:%C(yellow)%h%Cblue%d%Creset %s %C(white) %an, %ar%Creset"'
alias gl='glog --graph'
alias gla='gl --all'

alias gp='git push'
alias gpthis='gp origin $(git_current_branch)'
alias gpthis!='gp --set-upstream origin $(git_current_branch)'

alias gr='git reset'
alias grh='git reset --hard'
alias grsh='git reset --soft HEAD~'

alias grv='git remote -v'

alias gst='git stash'
alias gstp='git stash pop'

alias gup='git pull'

alias gsw='git switch'
alias gswc='git switch -c'

# Other useful aliases
oprjt() {
  local dir
  dir=$(cd ~/repos && ls -d */ | fzf --preview="tree -C {} | head -40") || return

  cd "$HOME/repos/$dir" || return
}
oprj() {
  oprjt
  code .
}
awssso() {
  local profile
  profile=$(
    awk '
      /^\[profile[[:space:]]+/ {
        gsub(/^\[profile[[:space:]]+|]$/, "", $0); print; next
      }
      /^\[default]$/ { print "default" }
    ' ~/.aws/config 2>/dev/null | sort -u | fzf --prompt="AWS profile> "
  ) || return 1

  # If user hit ESC / no selection
  [[ -z "$profile" ]] && return 0

  export AWS_PROFILE="$profile"
  echo "AWS_PROFILE set to: $AWS_PROFILE"
  aws sso login --profile "$AWS_PROFILE"
}
alias cls='clear'
alias c='code .'
alias ls='eza --icons'
alias ll='eza -lah --icons'
alias la='eza -a --icons'

# Terraform aliases
alias tff='terraform fmt -recursive'
alias tf='tff && terraform'
alias tfp='tf plan'
alias tfa='tf apply'
alias tfi='tf init'
alias tfs='tf show'

# Add local bin and conda to PATH
export DOT_LOCAL_DIR="$HOME/.local"
[[ -d $DOT_LOCAL_DIR/bin ]] && export PATH="$DOT_LOCAL_DIR/bin:$PATH"

export CONDA_DIR="/opt/conda"
[[ -d $CONDA_DIR/bin ]] && export PATH="$CONDA_DIR/bin:$PATH"

# Shell enhancements and customizations
eval "$(oh-my-posh init zsh --config ~/.oh-my-posh/themes/kushal.omp.json)"
source $(brew --prefix)/share/zsh-autosuggestions/zsh-autosuggestions.zsh
source $(brew --prefix)/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

# Enable searching through command history with up/down arrows
autoload -U up-line-or-beginning-search
autoload -U down-line-or-beginning-search
zle -N up-line-or-beginning-search
zle -N down-line-or-beginning-search
bindkey "^[[A" up-line-or-beginning-search # Up
bindkey "^[[B" down-line-or-beginning-search # Down

# Huge history
export HISTFILE="$HOME/.zsh_history"
export HISTSIZE=1000000000
export SAVEHIST=1000000000
setopt EXTENDED_HISTORY
