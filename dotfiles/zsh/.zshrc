#!/usr/bin/env zsh

#
# Executes commands at the start of an interactive session.
#
echo "Loading .zshrc"

######################################################################
# brew
unset BREW_DIR
BREW_DIR_INTEL=/usr/local/Homebrew
BREW_DIR_ARM=/opt/homebrew
[ -d $BREW_DIR_ARM ] && BREW_DIR=$BREW_DIR_ARM
[ -z $BREW_DIR ] && [ -d $BREW_DIR_INTEL ] && BREW_DIR=/usr/local

echo "${PATH}" | grep -q -s "${BREW_DIR}/bin"
[ $? -eq 1 ] && [ ! -z $BREW_DIR ] && export PATH="${BREW_DIR}/bin:${PATH}"
echo "${PATH}" | grep -q -s "${BREW_DIR}/sbin"
[ $? -eq 1 ] && [ ! -z $BREW_DIR ] && export PATH="${BREW_DIR}/sbin:${PATH}"

# if using the x86_64 brew install hack
# [ -d $BREW_DIR_INTEL ] && alias ibrew="arch -x86_64 /usr/local/bin/brew"
# [ -d $BREW_DIR_INTEL ] && echo "${PATH}" | grep -q -s "/usr/local/bin"
# [ $? -eq 1 ] && export PATH="/usr/local/bin:${PATH}"
# [ -d $BREW_DIR_INTEL ] && echo "${PATH}" | grep -q -s "/usr/local/sbin"
# [ $? -eq 1 ] && export PATH="/usr/local/sbin:${PATH}"

export PYTHONUSERBASE="$(dirname $(python -m site --user-base))/Current"

# Source Prezto
# Force yourself as the system's default user
me="$(whoami)"
export DEFAULT_USER=$me

unsetopt NOMATCH

zprezto_init="${ZDOTDIR:-${HOME}}/.zprezto/init.zsh"
# shellcheck source=/dev/null
[ -e "${zprezto_init}" ] && . "${zprezto_init}"

# Customize to your needs...

echo "${PATH}" | grep -q -s "${PYTHONUSERBASE}"
if [ $? -eq 1 ] ; then
  export PATH="${PYTHONUSERBASE}/bin:${PATH}"
fi

pipx_bin="${HOME}/.local/bin"
echo "${PATH}" | grep -q -s "${pipx_bin}"
if [ $? -eq 1 ] ; then
  export PATH="${pipx_bin}:${PATH}"
fi

# Editor
export EDITOR="/usr/bin/vim"

bindkey -v
bindkey -M viins 'jk' vi-cmd-mode

# 'Natural Text Editing' Key mappings don't appear to work nicely with vi key mappings since iTerm 3.5.6
# Un-tick "Treat ⌥ as Alt" in iTerm settings > Profile > Keys > General
# and remove all mappings from iTerm settings > Profile > Keys > Key mappings
# then add requirements here instead
bindkey '^[[1;9D' backward-word   # alt-ArrowLeft
bindkey '^[[1;9C' forward-word    # alt-ArrowRight

# History search
bindkey '^R' history-incremental-search-backward
bindkey '^F' history-incremental-search-forward

# Aliases
alias vim='/usr/bin/vim'
alias vi='/usr/bin/vim'
alias bt='wget --report-speed=bits http://cachefly.cachefly.net/100mb.test -O /dev/null'
alias fd='dscacheutil -flushcache'

## Command history configuration

if [ -z "$HISTFILE" ]; then
    HISTFILE=$HOME/.zsh_history
fi

export HISTSIZE=10000
export SAVEHIST=10000
export MAC_OS_VER=$(sw_vers -productVersion | sed -E 's/^([0-9]+)\.*.*$/\1/')

# Show history
case ${HIST_STAMPS} in
  "mm/dd/yyyy") alias history='fc -fl 1' ;;
  "dd.mm.yyyy") alias history='fc -El 1' ;;
  "yyyy-mm-dd") alias history='fc -il 1' ;;
  *) alias history='fc -i -l -D 0' ;;
esac

setopt append_history
setopt extended_history
setopt hist_expire_dups_first
setopt hist_ignore_dups # ignore duplication command history list
setopt hist_ignore_space
setopt hist_verify
setopt inc_append_history
setopt share_history # share command history data

export LESSOPEN="|/usr/local/bin/lesspipe.sh %s" LESS_ADVANCED_PREPROCESSOR=1

# set options for less
export LESS='--raw-control-chars'
# --ignore-case --status-column --LONG-PROMPT --HILITE-UNREAD --tabs= --quit-if-one-screen --no-init --window=-4
# or the short version
# export LESS='-F -i -J -M -R -W -x4 -X -z-4'

# Set colors for less. Borrowed from https://wiki.archlinux.org/index.php/Color_output_in_console#less .
export LESS_TERMCAP_mb=$'\E[1;31m'     # begin bold
export LESS_TERMCAP_md=$'\E[1;36m'     # begin blink
export LESS_TERMCAP_me=$'\E[0m'        # reset bold/blink
export LESS_TERMCAP_so=$'\E[01;44;33m' # begin reverse video
export LESS_TERMCAP_se=$'\E[0m'        # reset reverse video
export LESS_TERMCAP_us=$'\E[1;32m'     # begin underline
export LESS_TERMCAP_ue=$'\E[0m'        # reset underline

# some more ls aliases
alias ll='ls -alhF'
alias ln='ls -anhF'
alias la='ls -A'
# alias l='ls -CF'

alias h='history'
alias c='clear'
alias l='ls -al'
alias ..='cd ..'

# Some more alias to avoid making mistakes:
alias rm='rm -i'
alias cp='cp -i'
alias mv='mv -i'

alias ..='cd ..'
alias su='sudo su'
alias root='sudo su'
alias fvrestart='sudo fdesetup authrestart'

alias dtrace1="sudo dtrace -n 'syscall::open:entry{trace(execname);}'"
alias wifimon='open "/System/Library/CoreServices/Applications/Wireless Diagnostics.app"'
alias profile='code ~/.zshrc'
alias dev='cd ~/Development/'

# dev stuff
alias pris='code ~/Pristine'
alias update='~/Pristine/setup.sh'
# ENABLE / DISNABLE NVM updates by Pristine from the command line:
alias nvmyes="sed -E -i '' 's/^# (unset DISABLE_NVM_NODE_UPDATES)/\1/g' ${HOME}/Pristine/bin/16-node.sh"
alias nvmno="sed -E -i '' 's/^(unset DISABLE_NVM_NODE_UPDATES)/# \1/g' ${HOME}/Pristine/bin/16-node.sh"
alias brew1st='brew leaves | xargs brew deps --installed --for-each | sed "s/^.*:/$(tput setaf 4)&$(tput sgr0)/"'

alias g='bundle exec guard'
alias subl='code'
alias st='code'
alias mate='code'
alias a='code .'
alias sourceme='. ~/.zshrc'
alias spoofme='sudo spoof randomize en1' # see https://github.com/feross/spoo
alias t='tmux attach || tmux'
alias tls='tmux ls'
# shellcheck disable=SC2154
alias nettest='ping 1.1.1.1 | perl -nlE '"'"'use POSIX qw(strftime); $ts = strftime "%a %Y-%m-%d %H:%M:%S", localtime; print "$ts\t$_"'"'"''
alias nettestamazon='ping access-alexa-na.amazon.com | perl -nlE '"'"'use POSIX qw(strftime); $ts = strftime "%a %Y-%m-%d %H:%M:%S", localtime; print "$ts\t$_"'"'"''
alias iploc='curl -s -L https://ipinfo.io/ | jq'

# dropbox conflicted
alias conflicted='find ~/Library/CloudStorage/Dropbox -name "*conflicted*" -depth'
alias rmconflicted='conflicted -exec rm {} \;'
alias syncconflict='find ~/ -name "*sync-conflict*" -depth'
alias rmsyncconflict='syncconflict -exec rm {} \;'
alias dropboxclean='find ~/Library/CloudStorage/Dropbox -name "*conflicted copy*" -delete'

alias tf='terraform'

# docker-machine - installed with brew
alias dmm='docker-machine create --driver virtualbox DockerMachine'
alias dme='eval $(docker-machine env DockerMachine)'
alias dma='docker-machine start DockerMachine && dme'
alias dmz='docker-machine stop DockerMachine'
alias drmc='docker rm -f $(docker ps -a -q)'
alias drmi='docker rmi $(docker images -q)'

alias curl='$(brew --prefix)/opt/curl/bin/curl'

dir=~/Applications/dynamodb_local_latest
if [ -e ${dir} ]; then
  alias dynamodb'cd "${dir}"; java -Djava.library.path=./DynamoDBLocal_lib -jar DynamoDBLocal.jar -sharedDb'
else
  alias dynamodb='echo "first, install dynamodb locally at ${dir}...
  see https://docs.aws.amazon.com/amazondynamodb/latest/developerguide/DynamoDBLocal.html"'
fi

######################################################################
######################################################################
# Setup Language Environment helpers

######################################################################
# Cargo / Rust
[ -s "${HOME}/.cargo/env" ] && . "${HOME}/.cargo/env"  # This loads cargo
echo "${PATH}" | grep -q -s "${HOME}/.cargo/bin"
[ $? -eq 0 ] &&
  echo "Now using $(cargo --version)" &&
  echo "Now using $(rustc --version)"

######################################################################
# RBENV
if ((MAC_OS_VER >= 11)); then
  RUBY_VERSION=3.4.8
else
  RUBY_VERSION=3.3.9
fi
# https://github.com/rbenv/rbenv
# rbenv versions          # all local versions
# rbenv install -l        # all available versions
# rbenv install x.x.x     # install a particular version
# rbenv uninstall x.x.x   # uninstall a particular version
# rbenv rehash            # run after installing a new version
# rbenv global x.x.x      # set the version to be used globally

openssl_loc=$(brew --prefix openssl@3)
export RUBY_CONFIGURE_OPTS="--with-openssl-dir=${openssl_loc}"

echo "${PATH}" | grep -q -s "${HOME}/.rbenv/bin"
[ $? -eq 1 ] && export PATH="${HOME}/.rbenv/bin:${PATH}"

echo "${PATH}" | grep -q -s "${HOME}/.rbenv/shims"
[ $? -eq 1 ] && eval "$(rbenv init -)"

# rbenv rehash
if ! rbenv global "${RUBY_VERSION}"; then
  echo "install required version with:"
  echo "$ rbenv install ${RUBY_VERSION}"
fi

echo "Now using $(ruby --version)"

######################################################################
# GOLANG
export GOPATH="${HOME}/go"
echo "${PATH}" | grep -q -s "${GOPATH}/bin"
[ $? -eq 1 ] && export PATH="${GOPATH}/bin:${PATH}"

export CGO_CFLAGS_ALLOW="-Xpreprocessor"

echo "Now using $(go version)"

######################################################################
# NVM
# nvm install-latest-npm
# nvm ls-remote
# nvm install 21.1.0
# nvm uninstall 20.9.0
# nvm ls
# nvm unalias default
# nvm alias "default" "21.1.0"

if ((MAC_OS_VER < 11)); then
  export YARN_IGNORE_NODE=1
fi

export NVM_DIR="${HOME}/.nvm"
nvm_loc="${NVM_DIR}/nvm.sh"
# shellcheck source=/dev/null
[ -e "${nvm_loc}" ] && . "${nvm_loc}"                # This loads nvm
nvm use >/dev/null 2>&1                              # use version from .nvmrc
echo "Now using node $(nvm current) [npm v$(npm --version)] [yarn v$(yarn --version)]"

# add global node_modules to the PATH
echo "${PATH}" | grep -q -s "yarn/global/node_modules/.bin"
if [ $? -eq 1 ] ; then
  export PATH="${HOME}/.config/yarn/global/node_modules/.bin:${PATH}"
fi

# add local node_modules to the PATH
echo "${PATH}" | grep -q -s "\./node_modules/.bin"
if [ $? -eq 1 ] ; then
  export PATH="./node_modules/.bin:${PATH}"
fi

# nvm_shell_completion="${NVM_DIR}/bash_completion"
# # shellcheck source=/dev/null
# [ -e "${nvm_shell_completion}" ] && . "${nvm_shell_completion}"

######################################################################
# Python
# shortcut for global pip
gpip() {
    PIP_REQUIRE_VIRTUALENV=false pip "$@"
}
echo "Now using $(python --version 2>&1)"

######################################################################
# Java
# export JAVA_HOME="/usr/local/opt/openjdk"
# export CPPFLAGS="-I${JAVA_HOME}/include"
# echo "${PATH}" | grep -q -s "${JAVA_HOME}/bin"
# if [ $? -eq 1 ] ; then
#   export PATH="${JAVA_HOME}/bin:${PATH}"
# fi

echo "Now using $(java --version 2>&1)"

######################################################################
# OPENSSL 3.x
echo "${PATH}" | grep -q -s "openssl@3"
[ $? -eq 1 ] && export PATH="$(brew --prefix)/opt/openssl@3/bin:${PATH}"

######################################################################
# google-cloud-sdk

gcp_zsh_loc="$(brew --prefix)/Caskroom/google-cloud-sdk/latest/google-cloud-sdk/path.zsh.inc"
# shellcheck source=/dev/null
[ -e "${gcp_zsh_loc}" ] && . "${gcp_zsh_loc}"

gcp_zsh_completion="$(brew --prefix)/Caskroom/google-cloud-sdk/latest/google-cloud-sdk/completion.zsh.inc"
# shellcheck source=/dev/null
[ -e "${gcp_zsh_completion}" ] && . "${gcp_zsh_completion}"

######################################################################
# GPG macOS fix
tty_dev=$(tty)
export GPG_TTY=${tty_dev}

######################################################################
# Brew completions
# https://docs.brew.sh/Shell-Completion#configuring-completions-in-zsh
if type brew &>/dev/null; then
  echo "${FPATH}" | grep -q -s "$(brew --prefix)/share/zsh/site-functions"
  if [ $? -eq 1 ] ; then
    FPATH="$(brew --prefix)/share/zsh/site-functions:${FPATH}"
  fi
  autoload -Uz compinit
  compinit
fi

######################################################################
# Local bin
echo "${PATH}" | grep -q -s "\./bin"
[ $? -eq 1 ] && export PATH="./bin:${PATH}"

######################################################################
# "No" to NVM Bash completion
# grep -v "This loads nvm bash_completion" .zshrc > tmpfile && mv tmpfile .zshrc
sed -i '' '/^\[ -s "$NVM_DIR\/bash_completion" \]/d' ~/$(readlink ~/.zshrc)

######################################################################
# Source other files

echo

# source functions-dev
# shellcheck source=/dev/null
[ -e ~/.functions-dev ] &&. ~/.functions-dev

# source functions
# shellcheck source=/dev/null
[ -e ~/.functions ] && . ~/.functions

# keep sensitive / non-repo profile requirements in ~/.zsh_profile
# shellcheck source=/dev/null
[ -e ~/.zsh_profile ] && . ~/.zsh_profile

######################################################################
######################################################################
echo
if [ -n "$SSH_CONNECTION" ]; then
  echo "SSH Connection Info:"
  # Extract the remote and local connection details
  remote_ip=$(echo $SSH_CONNECTION | awk '{print $1}')
  remote_port=$(echo $SSH_CONNECTION | awk '{print $2}')
  local_ip=$(echo $SSH_CONNECTION | awk '{print $3}')
  local_port=$(echo $SSH_CONNECTION | awk '{print $4}')

  # Calculate the maximum length between remote_ip and local_ip
  col_width_ip=$(echo -e "$remote_ip\n$local_ip" | awk '{ print length($0) }' | sort -n | tail -n 1)

  # Calculate the maximum length between remote_port and local_port
  col_width_port=$(echo -e "$remote_port\n$local_port" | awk '{ print length($0) }' | sort -n | tail -n 1)

  # Display the formatted output with dynamic column width
  printf "Client: %-*s %*s\n" "$col_width_ip" "$remote_ip" "$col_width_port" "$remote_port"
  printf "Server: %-*s %*s\n" "$col_width_ip" "$local_ip" "$col_width_port" "$local_port"
  echo
fi

echo "Login and run command complete (.zshrc) as user: ${USER}"
echo
