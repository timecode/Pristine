#######################################################
# My zsh configuration
#######################################################

# Editor

export EDITOR="/usr/bin/vim"

# Source Prezto

if [[ -s "${ZDOTDIR:-$HOME}/.zprezto/init.zsh" ]]; then
  source "${ZDOTDIR:-$HOME}/.zprezto/init.zsh"
fi

# Customize to your needs...

bindkey -v
bindkey -M viins 'jk' vi-cmd-mode

# History search

bindkey "^R" history-incremental-search-backward
bindkey "^F" history-incremental-search-forward

# Aliases

alias vim="/usr/bin/vim"
alias vi="/usr/bin/vim"
alias bt="wget --report-speed=bits http://cachefly.cachefly.net/400mb.test > /dev/null"
# alias d="cd /Users/daniel/Desktop"
# alias www="cd /Users/daniel/Development/htdocs/"
alias zconf="vi ~/.zshrc"
alias zsource="source ~/.zshrc"
alias zhup="source ~/.zshrc"
alias vhup="source ~/.vimrc"
alias vconf="vim ~/.vimrc"
alias v="cd ~/.vim"
alias b="cd ~/.vim/bundle"
alias nc="ncat"
# alias traceroute="/usr/local/sbin/mtr"
alias fd="dscacheutil -flushcache"
alias filetree="ls -R | grep ":$" | sed -e 's/:$//' -e 's/[^-][^\/]*\//--/g' -e 's/^/ /' -e 's/-/|/'"
alias push="git push origin master"
alias comment="git commit -am"

export PATH="$PATH:$HOME/.rvm/bin" # Add RVM to PATH for scripting

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

alias h="history"
alias c="clear"
alias l="ls -al"
alias ll="ls -al | less"
alias ..="cd .."
alias su="sudo su"
alias root="sudo su"


alias dtrace1="sudo dtrace -n 'syscall::open:entry{trace(execname);}'"
alias wifimon="open \"/System/Library/CoreServices/Wi-Fi Diagnostics.app\""
alias profile="atom ~/.zshrc"
alias dev="cd ~/Dropbox/Development/"

# dev stuff
alias g='bundle exec guard'
alias subl='atom'
alias st='atom'
alias mate='atom'
alias a='atom .'
alias sourceme='source ~/.zshrc'
alias spoof="sudo spoof randomize en1" # see https://github.com/feross/spoof


export PATH="/usr/local/sbin:$PATH"

# added for rbenv
echo $PATH | grep -q -s "$HOME/.rbenv/bin"
if [ $? -eq 1 ] ; then
  export PATH="$HOME/.rbenv/bin":$PATH
fi
eval "$(rbenv init -)"

######################################################################
# VirtualEnv
export WORKON_HOME=$HOME/.virtualenvs
export PROJECT_HOME=$HOME/Dropbox/Development/python
alias mkve='mkvirtualenv'
alias setvep='setvirtualenvproject'
source /usr/local/bin/virtualenvwrapper.sh

### python 2 version
pynew() {
  echo "Creating new python virtualenv and project directory '$1' at $PWD/$1"
  mkvirtualenv $1 # --system-site-packages
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
py3new() {
  echo "Creating new python virtualenv and project directory '$1' at $PWD/$1"
  mkvirtualenv $1 # --system-site-packages
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

export GOPATH=$HOME/go
export PATH=$PATH:$GOPATH/bin
# export PATH=$PATH:/usr/local/opt/go/libexec/bin

# NVM
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

# Starling config
if [ -e /Users/robplayford/.starling/etc/profile ]; then
  . /Users/robplayford/.starling/etc/profile
else
  echo "Could not find '/Users/robplayford/.starling/etc/profile'"
fi

echo 'Login and run command complete'
echo
