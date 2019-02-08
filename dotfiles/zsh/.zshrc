echo "Loading .zshrc"

#
# Executes commands at the start of an interactive session.
#
# Authors:
#   Sorin Ionescu <sorin.ionescu@gmail.com>
#

# Source Prezto.
# Force yourself as the system's default user
DEFAULT_USER="$(whoami)"

unsetopt nomatch

if [[ -s "${ZDOTDIR:-$HOME}/.zprezto/init.zsh" ]]; then
  . "${ZDOTDIR:-$HOME}/.zprezto/init.zsh"
fi

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

HISTSIZE=10000
SAVEHIST=10000

# Show history
case $HIST_STAMPS in
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
alias wifimon="open '/System/Library/CoreServices/Applications/Wireless\ Diagnostics.app'"
alias profile="atom ~/.zshrc"
alias dev="cd ~/Dropbox/Development/"

# dev stuff
alias update='~/Pristine/setup.sh'
alias pris='atom ~/Pristine'
alias g='bundle exec guard'
alias subl='atom'
alias st='atom'
alias mate='atom'
alias a='atom .'
alias sourceme='. ~/.zshrc'
alias spoofme="sudo spoof randomize en1" # see https://github.com/feross/spoof
alias t="tmux attach || tmux"
alias tls="tmux ls"

# dropbox conflicted
alias conflicted="find ~/Dropbox -name \"*conflicted*\" -depth"
alias rmconflicted="conflicted -exec rm {} \;"
alias dropboxclean-'find ~/Dropbox -name "*conflicted copy*" -delete'

# docker-machine - installed with brew
alias dmm='docker-machine create --driver virtualbox DockerMachine'
alias dme='eval $(docker-machine env DockerMachine)'
alias dma='docker-machine start DockerMachine && dme'
alias dmz='docker-machine stop DockerMachine'

dir=~/Applications/dynamodb_local_latest
if [ -e ${dir} ]; then
  alias dynamodb="cd ${dir}; java -Djava.library.path=./DynamoDBLocal_lib -jar DynamoDBLocal.jar -sharedDb"
else
  alias dynamodb='echo "first, install dynamodb locally at ${dir}...
  see https://docs.aws.amazon.com/amazondynamodb/latest/developerguide/DynamoDBLocal.html"'
fi

######################################################################
######################################################################
# Setup Language Environment helpers

######################################################################
# RBENV
RUBY_VERSION=2.5.3
# https://github.com/rbenv/rbenv
# rbenv versions          # all local versions
# rbenv install -l        # all available versions
# rbenv install x.x.x     # install a particular version
# rbenv uninstall x.x.x   # uninstall a particular version
# rbenv rehash            # run after installing a new version
# rbenv global x.x.x      # set the version to be used globally
echo $PATH | grep -q -s "$HOME/.rbenv/bin"
if [ $? -eq 1 ] ; then
  export PATH="$HOME/.rbenv/bin":$PATH
fi
echo $PATH | grep -q -s "$HOME/.rbenv/shims"
if [ $? -eq 1 ] ; then
  eval "$(rbenv init -)"
fi
rbenv global ${RUBY_VERSION}
if [ $? -ne 0 ]; then
  echo "install required version with:"
  echo "$ rbenv install ${RUBY_VERSION}"
fi

echo "Now using $(ruby --version)"

######################################################################
# GOLANG
export GOPATH=$HOME/go
echo $PATH | grep -q -s "$GOPATH/bin"
if [ $? -eq 1 ] ; then
  export PATH="$GOPATH/bin":$PATH
fi

echo "Now using $(go version)"

######################################################################
# NVM
# nvm install-latest-npm
# nvm ls-remote
# nvm install 11.0.1
# nvm uninstall 11.0.0
# nvm ls
# nvm unalias default
# nvm alias "default" "11.0.1"
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
nvm use stable

######################################################################
# Python
echo "Now using $(python --version 2>&1)"

######################################################################
# Source other files

# source functions-dev
if [ -e ~/.functions-dev ]; then
  . ~/.functions-dev
fi

# source functions
if [ -e ~/.functions ]; then
  . ~/.functions
fi

# keep sensitive / non-repo profile requirements in ~/.zsh_profile
if [ -e ~/.zsh_profile ]; then
  . ~/.zsh_profile
fi

######################################################################
######################################################################
echo
echo 'Login and run command complete'
echo
