export ZSH="$HOME/.oh-my-zsh"
ZSH_THEME="catppuccin"
CATPPUCCIN_FLAVOR="mocha" # Required! Options: mocha, flappe, macchiato, latte
CATPPUCCIN_SHOW_TIME=true  # Optional! If set to true, this will add the current time to the prompt.
CATPPUCCIN_SHOW_HOSTNAME="never"  # Optional! Options: never, always, ssh
plugins=(git docker kubectl kubectx helm aws brew gh history terraform poetry ssh zsh-interactive-cd)

zstyle ':omz:alpha:plugins:kubectx' async-prompt force

source $ZSH/oh-my-zsh.sh

kube_prompt_segment() {
  local ctx="$(kubectx_prompt_info)"
  [[ -n "$ctx" ]] && print -n "%F{${catppuccin_sapphire}}⎈ ${ctx}%f "
}

[[ "$RPROMPT" != *kube_prompt_segment* ]] &&
  RPROMPT='$(kube_prompt_segment)'"${RPROMPT}"

# -----------------------------------------------------------------------------
# Custom aliases and functions -- these override the oh-my-zsh plugins above
#
# zsh expands aliases at PARSE time, so `gc() { ... }` is a syntax error when a
# `gc` alias already exists -- which it does on every `source ~/.zshrc`, left
# over from the previous pass. That was the
#   .zshrc:59: defining function based on alias `kubectl'
# error: kdp expanded to `kubectl describe pods`, kubectl expanded again to
# `kubecolor`, and the parser then hit `()`. Clear the names first.
# -----------------------------------------------------------------------------
unalias acd kdp kpl gc gsw oprj oprjt awssso awspf get_action_sha git_current_branch 2>/dev/null

# Helm aliases
alias h='helm'
alias hr='helm repo'
alias hra='helm repo add'

alias hs='helm search'
alias hsh='helm search hub --list-repo-url'
alias hsr='helm search repo'

alias hi='helm install'

# Istio aliases
alias ic='istioctl'

# Kubernetes aliases
alias kubectl='kubecolor'
alias k='kubectl'
# Give kubecolor kubectl's completions, since the alias hides the real binary.
(( $+functions[compdef] )) && compdef kubecolor=kubectl

alias kg='kubectl get'

alias kgp='kubectl get pods'
alias kgpa='kubectl get pods -A'
alias kgpwd='kubectl get pods -o wide'
alias kgpw='kubectl get pods --watch -o wide'

alias kgrs='kubectl get rs'
alias kgdep='kubectl get deploy'
alias kgev="kubectl get events -A -w --sort-by='.lastTimestamp'"

alias kap='kubectl apply -f'
alias kdel='kubectl delete -f'
alias krep='kubectl replace -f'
alias kdes='kubectl describe'
alias kroll='kubectl rollout'
alias kex='kubectl exec -it'
kdp() {
  local line
  line=$(kgpa | fzf --preview="kubectl describe pod {2} -n {1}")
  [[ -n "$line" ]] && kubectl describe pod $(echo "$line" | awk '{print $2}') -n $(echo "$line" | awk '{print $1}')
}
alias kl='kubectl logs'
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
alias kgx='kubectl config get-contexts'
alias kx='kubectl config use-context'
alias kgns='kubectl get namespaces'
alias kns='kubectl config set-context --current --namespace'

# ArgoCD core mode reads the argocd namespace from the CURRENT context's
# namespace and ignores --kube-context for that lookup, so a context sitting on
# `default` fails with `configmap "argocd-cm" not found`. Render a throwaway
# kubeconfig pinned to the picked context + argocd ns, so running this never
# moves the real current-context out from under your other shells.
#
# `command kubectl` throughout: the kubectl alias is kubecolor, and this output
# is piped into a kubeconfig rather than a terminal.
#
# `acd -c` re-runs the picker; otherwise the first pick sticks for the session.
acd() {
  local line kubeconfig

  if [[ "$1" == (-c|--context) || -z "$ACD_CONTEXT" ]]; then
    [[ "$1" == (-c|--context) ]] && shift

    # Blank the CURRENT column's `*` so NAME is always field 1.
    line=$(command kubectl config get-contexts | sed 's/^\*/ /' |
      fzf --header-lines=1 --prompt='argocd context> ') || return 1
    [[ -z "$line" ]] && return 1

    export ACD_CONTEXT=$(print -r -- "$line" | awk '{print $1}')
  fi

  kubeconfig="${TMPDIR:-/tmp}/acd-kubeconfig-$$"
  command kubectl config view --raw > "$kubeconfig" || return 1
  KUBECONFIG="$kubeconfig" command kubectl config use-context "$ACD_CONTEXT" >/dev/null || return 1
  KUBECONFIG="$kubeconfig" command kubectl config set-context "$ACD_CONTEXT" \
    --namespace=argocd >/dev/null || return 1

  KUBECONFIG="$kubeconfig" argocd --core "$@"
}

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
alias gf='git fetch'
alias gfo='git fetch origin'

alias gswc='git switch -c'

gsw() {
  if [[ $# -gt 0 ]]; then
    git checkout "$@"
  else
    git branch -av | fzf --preview="git log --oneline --graph --decorate --color {1}" | awk "{print \$1}" | xargs git checkout
  fi
}

# Other useful aliases
oprjt() {
  local dir
  dir=$(cd ~/repos && ls -d */ | fzf --preview="tree -C {} | head -40") || return

  cd "$HOME/repos/$dir" || return
}
oprj() {
  oprjt
  nvim .
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
awspf() {
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

# tmux
alias tm='tmux'

tmcd() {
  local s=$(tmux ls | fzf | cut -d: -f1)
  [[ -n $s ]] && tmux a -t "$s"
}

ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE="fg=#6c7086"

source $(brew --prefix)/share/zsh-autosuggestions/zsh-autosuggestions.zsh
source $(brew --prefix)/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

# Huge history. Must come after oh-my-zsh.sh, which sets its own HISTSIZE and
# SAVEHIST in lib/history.zsh and would otherwise win.
export HISTFILE="$HOME/.zsh_history"
export HISTSIZE=10000000000
export SAVEHIST=10000000000
setopt EXTENDED_HISTORY
