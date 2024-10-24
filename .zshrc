# Export 
export PATH="$PATH:/home/irotnep/.local/bin"
export PATH="$PATH:$HOME/tools"
export ZSH="$HOME/.oh-my-zsh"

export VAULT_ADDR='https://vault-api.infra.status.im:8200'
# Magically link PYTHONPATH to the ZSH array pythonpath
typeset -T PYTHONPATH pythonpath
# Hacky way to provide python packages to Ansible for local tasks.
if [[ -d /etc/profiles/per-user ]]; then
    for SITE_PACKAGES in /etc/profiles/per-user/$USER/lib/python3.*/site-packages; do
        export PYTHONPATH="${PYTHONPATH}:${SITE_PACKAGES}"
    done
fi
# Remove duplicates
typeset -U pythonpath
export PYTHONPATH

ZSH_THEME="agnoster"
ZSH_TMUX_AUTOSTART=true
source $ZSH/oh-my-zsh.sh

if [ -n "${commands[fzf-share]}" ]; then
  source "$(fzf-share)/key-bindings.zsh"
  source "$(fzf-share)/completion.zsh"
fi

# Replace Capslock with Ctrl:
# Not working with Wayland
#setxkbmap -layout us -option ctrl:swapcaps

# SSH configuration for GPG

export GPG_TTY="$(tty)"
export SSH_AUTH_SOCK=$(gpgconf --list-dirs agent-ssh-socket)
gpgconf --launch gpg-agent
gpg-connect-agent updatestartuptty /bye > /dev/null
export PATH="${PATH}:${HOME}/snippet"

# Exports
if which nvim >/dev/null; then
    EDITOR="nvim"
    alias vim='nvim'
else
    EDITOR="vim"
fi
# Vim movement
set -o vi

# Completion
# history of changing directories (cd)
setopt AUTO_PUSHD                 # pushes the old directory onto the stack
setopt PUSHD_MINUS                # exchange the meanings of '+' and '-'
setopt CDABLE_VARS                # expand the expression (allows 'cd -2/tmp')
zstyle ':completion:*:directory-stack' list-colors '=(#b) #([0-9]#)*( *)==95=38;5;12'

# Aliases
alias ll='ls -lh --color'
alias grep='grep --color -i'
alias c='curl -sslf'
alias ap='ansible-playbook -d'
alias cm='clipmenu'
alias p="playerctl"

# Function


# reload zshrc
function src() {
    autoload -U zrecompile
    [[ -f ~/.zshrc ]] && zrecompile -p ~/.zshrc
    [[ -f ~/.zcompdump ]] && zrecompile -p ~/.zcompdump
    [[ -f ~/.zcompdump ]] && zrecompile -p ~/.zcompdump
    [[ -f ~/.zshrc.zwc.old ]] && rm -f ~/.zshrc.zwc.old
    [[ -f ~/.zcompdump.zwc.old ]] && rm -f ~/.zcompdump.zwc.old
    source ~/.zshrc
}

function switch-yubikey() {
  gpg-connect-agent "scd serialno" "learn --force" /bye
}

# g as simple shortcut for git status or just git if any other arguments are given
function g {
    if [[ $# > 0 ]]; then
        git "$@"
    else
        git status -sb
    fi
}
compdef g=git

if type docker > /dev/null; then
    function d {
        if [[ $1 == 'clean' ]]; then
            docker rm $(docker ps -a -q)
        elif [[ $1 == 'cleanimages' ]]; then
            docker rmi $(docker images -f dangling=true -q)
        elif [[ $# > 0 ]]; then
            docker "$@"
        else
            docker ps
        fi
    }
    compdef d=docker
fi


function s {
    if [[ $# == 0 ]]; then
        sudo systemctl list-units --type=service --state=running
    elif [[ $# == 1 ]]; then
        sudo systemctl status "$@"
    else
        sudo systemctl "$@"
    fi
}
compdef s=systemctl

function j {
    if [[ $# == 0 ]]; then
        sudo journalctl --lines=30 --follow
    elif [[ $# == 1 ]]; then
        sudo journalctl --lines=30 --follow --unit "$@"
    else
        sudo journalctl "$@"
    fi
}
compdef j=journalctl

function t {
    if [[ $# == 0 ]]; then
        terraform plan
    elif [[ $1 == "w" ]]; then
        if [[ $# == 1 ]]; then
           terraform workspace list
        elif [[ $# == 2 ]]; then
            echo "Selecting workspace ${2}"
            terraform workspace select "$2"
        else
            terraform workspqce "$2..@"
        fi
    else
        terraform "$@"
    fi
}

function a {
    if [[ $# == 0 ]]; then
        ansible localhost -m debug -a 'var=groups'
    else
        ansible "$@"
    fi
}
compdef a=ansible


function a-p {
  if [[ $# == 1 ]]; then
    ansible-playbook ansible/$1
  elif [[ $# == 2 ]]; then
    ansible-playbook ansible/"$1" -t "$2"
  else
    ansible-playbook "$@"
  fi
}

function select-work-dir() {
    echo "${HOME}"
    WORK_DIR="${HOME}/work"
    SELECTED=$(ls "${WORK_DIR}" | fzf)
    [[ -n "${SELECTED}" ]] && cd "${WORK_DIR}/${SELECTED}"
    echo
    zle reset-prompt
}
zle     -N select-work-dir
bindkey '^a' select-work-dir

function export-working-vars() {
  echo 'Exporting vars for Ansible & Terraform'
  export PASSWORD_STORE_DIR=/home/irotnep/.password-store
  export CONSUL_HTTP_TOKEN=$(pass services/consul/http_token)
  export VAULT_TOKEN=$(pass personnal/vault/token)
  eval "$(bw unlock $(pass personnal/bitwarden ) |grep "$ export" | cut -b 3-)"
  export PASSWORD_STORE_DIR=/home/irotnep/work/infra-pass
}
zle -N export-working-vars
bindkey '^w' export-working-vars


# auto completion for ssh hosts
function fzf-ssh () {
  local hosts=$(awk -F '[, ]' '{if ($1 ~ /[a-z]/) {print $1}}' ~/.ssh/known_hosts)
  local domains=$(grep CanonicalDomains ~/.ssh/config | cut -f 2- -d ' ' | tr ' ' '|')
  local selected_host=$(echo $hosts | sed -E "s/\.(${domains})//" | sort -u | fzf --query "$LBUFFER")

  if [ -n "${selected_host}" ]; then
    BUFFER="ssh ${selected_host}"
    zle accept-line
  fi
  zle reset-prompt
}

zle -N fzf-ssh
bindkey '^s' fzf-ssh

function reload-gpg() {
  gpgconf --launch gpg-agent
  gpg-connect-agent updatestartuptty /bye > /dev/null
}

eval $(thefuck --alias)

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
export PATH=~/bin:$PATH

export ANSIBLE_REPOS_PATH="$HOME/work"
export ANSIBLE_BOOTSTRAP_USER="$USER"

# Auto Completion
function fzf-systemctl () {
  local services=$(systemctl list-units --type=service --plain | awk '/.service/{print $1}')
  local selected=$(
    echo "${services}" | fzf \
        --query "$LBUFFER" \
        --preview='sudo SYSTEMD_COLORS=1 systemctl status ${1}' \
        --preview-window=bottom,22
  )
  if [ -n "${selected}" ]; then
    BUFFER="sudo systemctl --no-pager status ${selected}"
    zle accept-line
  fi
  zle reset-prompt
}

zle -N fzf-systemctl
bindkey '^u' fzf-systemctl


# Auto Completion
function fzf-docker () {
  local services=$(docker ps --format "table {{.Names}}" )
  local selected=$(
    echo "${services}" | fzf \
        --query "$LBUFFER" \
        --preview='docker logs -f -n 50 ${1}' \
        --preview-window=bottom,50
  )
  if [ -n "${selected}" ]; then
    BUFFER="docker logs -f -n 50 ${selected}"
    zle accept-line
  fi
  zle reset-prompt
}

zle -N fzf-docker
bindkey '^k' fzf-docker

function fzf-git () {
  local services=$( git branch --list | cat - )
  local selected=$(
    echo "${services}" | fzf --query "$LBUFFER" \
        --preview='git log --oneline --graph ${1}' \
        --preview-window=bottom,40
  )
  if [ -n "${selected}" ]; then
    BUFFER="git switch ${selected}"
    zle accept-line
  fi
  zle reset-prompt
}

zle -N fzf-git
bindkey '^g' fzf-git

function clean-docker-container {
  if [[ $# == 0 ]]; then
    docker rm $(docker ps -a | tail -n +2 |awk '{print $1}')
  fi
  if [[ $1 == "f" ]]; then
    docker stop $( docker ps | tail -n +2 | awk '{print $1}')
    docker rm $(docker ps -a | tail -n +2 | awk '{print $1}')
  fi

}

function fzf-vault () {
  local secrets_path=$(vault kv get -format=json -mount=metadata list-secrets | jq -r '.data.data.key' | jq -r '.[]' )
  local selected=$(
    echo "${secrets_path}" | fzf \
        --query "$LBUFFER" \
        --preview='vault kv get -mount=secret -format=json ${1} | jq ".data.data" | jq "keys[]"' \
        --sync \
        --preview-window=bottom,10
  )
  if [ -n "${selected}" ]; then
    BUFFER="vault kv get -mount=secret ${selected}"
    zle accept-line
  fi
  zle reset-prompt
}
zle -N fzf-vault
bindkey '^v' fzf-vault

function v {
  if [[ $# == 0 ]]; then
    vault status
  elif [[ $1 == "p" ]]; then
    vault kv put -mount=secret "$2" "$3"
  elif [[ $1 == "g" ]]; then
    vault kv get -mount=secret "$2"
  elif [[ $1 == "l" ]]; then
    vault kv list -mount=secret "$2"
  else
    vault "$@"
  fi
}

zle-keymap-select () {
    [[ $KEYMAP = vicmd ]] \
        && echo -ne "\033]12;Red\007" \
        || echo -ne "\033]12;White\007"
}
zle-line-finish () { zle -K viins; echo -ne "\033]12;White\007"; }
zle-line-init () { zle -K viins; echo -ne "\033]12;White\007"; }
# Enable Vi mode.
bindkey -v
if [[ $TERM != "linux" ]]; then # Only if terminal is graphical.
    zle -N zle-keymap-select
    zle -N zle-line-finish
    zle -N zle-line-init
fi

bindkey "^E" edit-command-line

function o {
  if [[ $1 == "c" ]]; then
    sudo openssl x509 -text -noout -in $2
  elif [[ $1 == "k" ]]; then
    sudo openssl rsa -text -modulus -noout -in $2
  else
    sudo openssl "$@"
  fi
}

function notes {
    NOTES_DIR="${HOME}/Documents/notes/"
    SELECTED=$(ls "${NOTES_DIR}" | fzf)
    [[ -n "${SELECTED}" ]] && cd "${NOTES_DIR}/${SELECTED}" && vim ./
}

function wksp {
    WKSP_DIR="${HOME}/work/workspace"
    SELECTED=$(ls "${WKSP_DIR}" | fzf)
    [[ -n "${SELECTED}" ]] && cd "${WKSP_DIR}/${SELECTED}" 
    ls -all
}

eval "$(direnv hook zsh)"
