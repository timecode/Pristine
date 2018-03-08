#
# Executes commands at the start of an interactive session.
#
# Authors:
#   Sorin Ionescu <sorin.ionescu@gmail.com>
#

# Source Prezto.
if [[ -s "${ZDOTDIR:-$HOME}/.zprezto/init.zsh" ]]; then
  source "${ZDOTDIR:-$HOME}/.zprezto/init.zsh"
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
alias wifimon="open '/System/Library/CoreServices/Wi-Fi Diagnostics.app'"
alias profile="atom ~/.zshrc"
alias dev="cd ~/Dropbox/Development/"

# dev stuff
alias g='bundle exec guard'
alias subl='atom'
alias st='atom'
alias mate='atom'
alias a='atom .'
alias sourceme='source ~/.zshrc'
alias spoofme="sudo spoof randomize en1" # see https://github.com/feross/spoof
alias t="tmux attach || tmux"
alias tls="tmux ls"

######################################################################
# NVM
# nvm install-latest-npm
# nvm ls-remote
# nvm install 9.8.0
# nvm uninstall 9.7.1
# nvm ls
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
nvm use node

######################################################################
# RBENV
# https://github.com/rbenv/rbenv
# rbenv versions          # all local versions
# rbenv install -l        # all available versions
# rbenv install x.x.x     # install a particular version
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
rbenv global 2.5.0

######################################################################
# GOLANG
export GOPATH=$HOME/go
echo $PATH | grep -q -s "$GOPATH/bin"
if [ $? -eq 1 ] ; then
  export PATH="$GOPATH/bin":$PATH
fi

######################################################################
# python2
export PATH="/usr/local/opt/python@2/bin:$PATH"

######################################################################
# VirtualEnv
export WORKON_HOME=$HOME/.virtualenvs
export PROJECT_HOME=$HOME/Dropbox/Development/python
alias mkve='mkvirtualenv'
alias setvep='setvirtualenvproject'
source /usr/local/bin/virtualenvwrapper.sh

### python 2 version
py2new() {
  echo "Creating new python virtualenv and project directory '$1' at $PWD/$1"
  mkvirtualenv -p python2 $1 # --system-site-packages
  workon $1
  pip2 install -U pyscaffold
  putup --with-tox $1 $2
  cd $1
  setvirtualenvproject
  workon $1
  pip2 install -U pytest
  sed -i '' -- 's/\(--cov-report \)term-missing/\1html/g' setup.cfg
  pip2 install -U watchdog
  pip2 install -U tox
  git commit -a -m "Basic project setup"
  cat <<-____EOF

Add new files alongside the auto-genereated 'skeleton' and 'test_skeleton' files.

$ pynew project-name [--update|--force]
# --update to update an existing project
# --force to overwrite an existing directory

To run tests MANUALLY:
$ python setup.py test

To run tests AUTOMATICALLY:
$ pyautotest

To view test coverage:
$ open htmlcov/index.html

____EOF
  atom .
}
# call above with
# $ pynew foo [--update|--force]

### python 3 version
pynew() {
  echo "Creating new python virtualenv and project directory '$1' at $PWD/$1"
  mkvirtualenv -p python3 $1 # --system-site-packages
  workon $1
  pip3 install -U pyscaffold
  putup --with-tox $1 $2
  cd $1
  setvirtualenvproject
  workon $1
  pip3 install -U pytest
  sed -i '' -- 's/\(--cov-report \)term-missing/\1html/g' setup.cfg
  pip3 install -U watchdog
  pip3 install -U tox
  git commit -a -m "Basic project setup"
  cat <<-____EOF

Add new files alongside the auto-genereated 'skeleton' and 'test_skeleton' files.

$ py3new project-name [--update|--force]
# --update to update an existing project
# --force to overwrite an existing directory

To run tests MANUALLY:
$ python3 setup.py test

To run tests AUTOMATICALLY:
$ pyautotest

To view test coverage:
$ open htmlcov/index.html

____EOF
  atom .
}
# call above with
# $ py3new foo [--update|--force]
######################################################################

# keep sensitive / non-repo profile requirements in ~/.zsh_profile
if [ -e ~/.zsh_profile ]; then
  . ~/.zsh_profile
fi

# Starling config
if [ -e /Users/robplayford/.starling/etc/profile ]; then
  . /Users/robplayford/.starling/etc/profile
else
  echo "Could not find '/Users/robplayford/.starling/etc/profile'"
fi

echo 'Login and run command complete'
echo
