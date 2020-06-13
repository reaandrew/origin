# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:/usr/local/bin:$PATH

# Path to your oh-my-zsh installation.
export ZSH=$HOME/.oh-my-zsh

# Set name of the theme to load --- if set to "random", it will
# load a random theme each time oh-my-zsh is loaded, in which case,
# to know which specific one was loaded, run: echo $RANDOM_THEME
# See https://github.com/robbyrussell/oh-my-zsh/wiki/Themes
ZSH_THEME="robbyrussell"

plugins=(git ssh-agent)

# Sources
source $ZSH/oh-my-zsh.sh
source $HOME/.cargo/env

# User configuration

# Preferred editor for local and remote sessions
export EDITOR='vim'

export KUBECONFIG=$HOME/.kube/config

export PATH=~/.local/bin:$PATH
export PATH=~/.bin:$PATH
export PATH=~/go/bin:$PATH
export PATH=/snap/bin/:$PATH

#alias ls='ls -hAl $@'
alias lsd='ls -d */'
alias dls='docker ps $@'
alias dli='docker images $@'
alias ver='git describe | cut -d- -f1,2 | tr - .'
alias cdt='cd $(mktemp -d)'
alias test-tls='openssl s_client -showcerts -connect $1 < /dev/null'
alias pgspy='java -jar "$SPY" -dp "$PG_DRIVER" -t pgsql $@'
alias vcurl='curl -s -w "@/root/scripts/curl-format.txt" -o /dev/null -v $@'
alias export_find='export | grep -i $@'
alias aws_services="(aws list-commands 2>&1) | tr -s ' ' | sed 's/|//g' | xargs -n1 | sort"
alias checkstyle='java -jar /opt/checkstyle.jar -c /opt/checks.xml $(find ./ -not -path "*test*" -and -not -path "*generated*" -and -name "*.java")'
alias dynamodb_local='docker run -p 8000:8000 amazon/dynamodb-local'
function pip_install(){
  pip install $1 && pip freeze > requirements.txt
}

function git_delete_tag(){
  git push --delete origin $1
  git tag -d $1
}

function show_certs(){
  HOST="$1"
  openssl s_client -showcerts -connect "$HOST:443" -servername "$HOST" -tlsextdebug < /dev/null
}

function show_x509(){
  HOST="$1"
  openssl s_client -showcerts -connect "$HOST:443" -servername "$HOST" -tlsextdebug < /dev/null | openssl x509 -text
}

function aws_config_to_env(){
  PROFILE=${1:-default}
  START=$(grep -En "\[.*$PROFILE\]" ~/.aws/config | cut -d: -f1); sed -n "$((START+1)),$((START+2))p" < ~/.aws/credentials | tr -d " " | awk '{split($1,a,"="); printf "export %s=\"%s\"\n", toupper(a[1]), a[2]}'
  START=$(grep -En "\[.*$PROFILE\]" ~/.aws/config | cut -d: -f1); sed -n "$((START+1)),$((START+2))p" < ~/.aws/config | tr -d " " | awk '{split($1,a,"="); printf "export AWS_DEFAULT_%s=\"%s\"\n", toupper(a[1]), a[2]}'
}

function git_update_branches() {
  BRANCH_NAME=${1:-BRANCH_NAME_NOT_SET}
  SOURCE_BRANCH=${2:-SOURCE_BRANCH_NOT_SET}
  for i in `find  ./ -maxdepth 1`;do (cd $i && (git checkout "$BRANCH_NAME" || :) && (git pull --no-edit origin "$BRANCH_NAME" || :) && (git pull --no-edit origin "$SOURCE_BRANCH" || :) && (git push -u origin "$BRANCH_NAME")); done;
}

function validate_json(){
  if jq -e . >/dev/null 2>&1 <<<"$1"; then
      echo "Parsed JSON successfully and got something other than false/null"
  else
      echo "Failed to parse JSON, or got false/null"
  fi
}

function watch_file(){
  while inotifywait -e close_write "$1"; do eval "$2"; done
}

function json_escape () {
    printf '%s' "$1" | python -c 'import json,sys; print(json.dumps(sys.stdin.read()))'
}

function make_ram_disk () {
  mkdir -p /mnt/ramdisk
  sudo mount -t tmpfs -o rw,size=2G tmpfs /mnt/ramdisk
}

# Set up the prompt
autoload -Uz promptinit
promptinit

# Use modern completion system
autoload -Uz compinit
compinit

setopt -o incappendhistory
setopt histignorealldups sharehistory

export HISTSIZE=10000000000000
export SAVEHIST=10000000000000
export HISTFILE=~/.zsh_history
export LANG="en_GB.UTF-8"
export LANGUAGE="en_GB.UTF-8"
export LC_ALL="en_GB.UTF-8"

# POWERLINE
export POWERLINE_ROOT=$((pip3 show powerline-status | grep Location | cut -d: -f2 | tr -d " ") || :)
. ${POWERLINE_ROOT}/powerline/bindings/zsh/powerline.zsh || :

# GIT
git config --global user.name "Andy Rea"
git config --global user.email email@andrewrea.co.uk
git config --global core.editor "vim"

# GOLANG
export PATH=$PATH:/usr/local/go/bin

# NODE
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

export GITHUB_TOKEN=${$(cat ~/.ssh/github_token 2> /dev/null || :):-NOTSET}

# Auto complete for AWS CLI
# source ~/.local/bin/aws_zsh_completer.sh

# eval "$(direnv hook zsh)"

# setxkbmap -option ctrl:nocaps

if [ -f ~/.docker_aliases ]; then
  . ~/.docker_aliases
fi

alias dockershell="docker run --rm -i -t --entrypoint=/bin/bash"
alias dockershellsh="docker run --rm -i -t --entrypoint=/bin/sh"

function dockershellhere() {
    dirname=${PWD##*/}
    docker run --rm -it --entrypoint=/bin/bash -v `pwd`:/${dirname} -w /${dirname} "$@"
}
function dockershellshhere() {
    dirname=${PWD##*/}
    docker run --rm -it --entrypoint=/bin/sh -v `pwd`:/${dirname} -w /${dirname} "$@"
}
