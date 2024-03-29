# Export 
export PATH="$PATH:/home/irotnep/.local/bin"
export PATH="$PATH:$HOME/tools"
export ZSH="$HOME/.oh-my-zsh"

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

plugins=(
	git
	thefuck
	thor
	docker
	ag
	cp
	history
	terraform
	ansible
	vagrant
	)

source $ZSH/oh-my-zsh.sh

# SSH configuration for GPG

export GPG_TTY="$(tty)"
export SSH_AUTH_SOCK=$(gpgconf --list-dirs agent-ssh-socket)
gpgconf --launch gpg-agent
gpg-connect-agent updatestartuptty /bye > /dev/null

# Exports 
if which nvim >/dev/null; then
    EDITOR="nvim"
    alias vim='nvim'
else
    EDITOR="vim"
fi

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

function select-work-dir() {
    echo "${HOME}"
    WORK_DIR="${HOME}/work"
    SELECTED=$(ls "${WORK_DIR}" | fzf)
    [[ -n "${SELECTED}" ]] && cd "${WORK_DIR}/${SELECTED}"
    echo
    zle reset-prompt
}
zle     -N   select-work-dir
bindkey '^a' select-work-dir

function export-working-vars() {
  echo 'Exporting vars for Ansible & Terraform'
  export PASSWORD_STORE_DIR=/home/irotnep/.password-store
  export CONSUL_HTTP_TOKEN=$(pass services/consul/http_token)
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


function export-dotfile(){
  scp $HOME/projects/infra-role-bootstrap-linux/files/users/irotnep/config/.zshrc "$1":/home/irotnep/
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
    BUFFER="docker logs -f -n 50  ${selected}"
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

function launch-llama {
  MODEL="$HOME/tools/models/Mistral-7B-v0.1/ggml-model_q4_1"
  echo "Launching Llama.cpp with models ${MODEL}"
  $HOME/tools/llama.cpp/server -m "${MODEL}" -c 1024
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
