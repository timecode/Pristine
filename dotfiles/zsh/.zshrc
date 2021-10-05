#!/usr/bin/env zsh

#
# Executes commands at the start of an interactive session.
#
echo "Loading .zshrc"

# Source Prezto
# Force yourself as the system's default user
me="$(whoami)"
export DEFAULT_USER=$me

unsetopt NOMATCH

zprezto_init="${ZDOTDIR:-${HOME}}/.zprezto/init.zsh"
# shellcheck source=/dev/null
[ -e "${zprezto_init}" ] && . "${zprezto_init}"

# Customize to your needs...

# Editor
export EDITOR="/usr/bin/vim"

bindkey -v
bindkey -M viins 'jk' vi-cmd-mode

# History search
bindkey "^R" history-incremental-search-backward
bindkey "^F" history-incremental-search-forward

# Aliases
alias vim="/usr/bin/vim"
alias vi="/usr/bin/vim"
alias bt="wget --report-speed=bits http://cachefly.cachefly.net/100mb.test > /dev/null"
alias fd="dscacheutil -flushcache"

## Command history configuration

if [ -z "$HISTFILE" ]; then
    HISTFILE=$HOME/.zsh_history
fi

export HISTSIZE=10000
export SAVEHIST=10000

# Show history
case ${HIST_STAMPS} in
  "mm/dd/yyyy") alias history='fc -fl 1' ;;
  "dd.mm.yyyy") alias history='fc -El 1' ;;
  "yyyy-mm-dd") alias history='fc -il 1' ;;
  *) alias history='fc -l 1' ;;
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

alias h="history"
alias c="clear"
alias l="ls -al"
alias ll="ls -al | less"
alias ..="cd .."
alias su="sudo su"
alias root="sudo su"

alias dtrace1="sudo dtrace -n 'syscall::open:entry{trace(execname);}'"
alias wifimon='open "/System/Library/CoreServices/Applications/Wireless Diagnostics.app"'
alias profile="code ~/.zshrc"
alias dev="cd ~/Development/"

# dev stuff
alias pris='code ~/Pristine'
alias update='~/Pristine/setup.sh'
# ENABLE / DISNABLE NVM updates by Pristine from the command line:
alias nvmyes="sed -E -i '' 's/^# (unset DISABLE_NVM)/\1/g' ${HOME}/Pristine/bin/16-node.sh"
alias nvmno="sed -E -i '' 's/^(unset DISABLE_NVM)/# \1/g' ${HOME}/Pristine/bin/16-node.sh"

alias g='bundle exec guard'
alias subl='code'
alias st='code'
alias mate='code'
alias a='code .'
alias sourceme='. ~/.zshrc'
alias spoofme="sudo spoof randomize en1" # see https://github.com/feross/spoof
alias t="tmux attach || tmux"
alias tls="tmux ls"
# shellcheck disable=SC2154
alias nettest='ping 1.1.1.1 | perl -nlE '"'"'use POSIX qw(strftime); $ts = strftime "%a %Y-%m-%d %H:%M:%S", localtime; print "$ts\t$_"'"'"''

# dropbox conflicted
alias conflicted="find ~/Dropbox -name \"*conflicted*\" -depth"
alias rmconflicted="conflicted -exec rm {} \;"
alias dropboxclean-'find ~/Dropbox -name "*conflicted copy*" -delete'

alias tf="terraform"

# docker-machine - installed with brew
alias dmm='docker-machine create --driver virtualbox DockerMachine'
alias dme='eval $(docker-machine env DockerMachine)'
alias dma='docker-machine start DockerMachine && dme'
alias dmz='docker-machine stop DockerMachine'
alias drmc='docker rm -f $(docker ps -a -q)'
alias drmi='docker rmi $(docker images -q)'

alias curl='/usr/local/opt/curl/bin/curl'

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
# RBENV
RUBY_VERSION=3.0.2
# https://github.com/rbenv/rbenv
# rbenv versions          # all local versions
# rbenv install -l        # all available versions
# rbenv install x.x.x     # install a particular version
# rbenv uninstall x.x.x   # uninstall a particular version
# rbenv rehash            # run after installing a new version
# rbenv global x.x.x      # set the version to be used globally

openssl_loc=$(brew --prefix openssl@1.1)
export RUBY_CONFIGURE_OPTS="--with-openssl-dir=${openssl_loc}"

echo "${PATH}" | grep -q -s "${HOME}/.rbenv/bin"
[ $? -eq 1 ] && export PATH="${HOME}/.rbenv/bin":${PATH}

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
[ $? -eq 1 ] && export PATH="${GOPATH}/bin":${PATH}

echo "Now using $(go version)"

######################################################################
# NVM
# nvm install-latest-npm
# nvm ls-remote
# nvm install 16.5.0
# nvm uninstall 16.5.0
# nvm ls
# nvm unalias default
# nvm alias "default" "16.5.0"
export NVM_DIR="${HOME}/.nvm"
nvm_loc="${NVM_DIR}/nvm.sh"
nvm_shell_completion="${NVM_DIR}/bash_completion"
# shellcheck source=/dev/null
[ -e "${nvm_loc}" ] && . "${nvm_loc}"                # This loads nvm
# shellcheck source=/dev/null
[ -e "${nvm_shell_completion}" ] && . "${nvm_shell_completion}"
nvm use stable

######################################################################
# Python
# shortcut for global pip
gpip() {
    PIP_REQUIRE_VIRTUALENV=false pip "$@"
}
echo "Now using $(python --version 2>&1)"

######################################################################
# Java
export JAVA_HOME="/usr/local/opt/openjdk"
export CPPFLAGS="-I${JAVA_HOME}/include"
echo "${PATH}" | grep -q -s "${JAVA_HOME}/bin"
if [ $? -eq 1 ] ; then
  export PATH="${JAVA_HOME}/bin:${PATH}"
fi

echo "Now using $(java --version 2>&1)"

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
# OPENSSL 1.1
echo "${PATH}" | grep -q -s "openssl@1.1"
[ $? -eq 1 ] && export PATH="/usr/local/opt/openssl@1.1/bin:${PATH}"

######################################################################
# google-cloud-sdk

gcp_zsh_loc="/usr/local/Caskroom/google-cloud-sdk/latest/google-cloud-sdk/path.zsh.inc"
# shellcheck source=/dev/null
[ -e "${gcp_zsh_loc}" ] && . "${gcp_zsh_loc}"

gcp_zsh_completion="/usr/local/Caskroom/google-cloud-sdk/latest/google-cloud-sdk/completion.zsh.inc"
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
# Cargo
[ -s "${HOME}/.cargo/env" ] && . "${HOME}/.cargo/env"  # This loads cargo

######################################################################
######################################################################
echo
echo 'Login and run command complete'
echo
