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
alias ds="dd if=/dev/zero of=/tmp/output.img bs=8k count=256k"
# alias nb="vim +BlogNew"
# alias np="vim +BlogNew\ page"
# alias eb="vim +BlogList"
# alias ep="vim +BlogList\ page"
# alias ems="vi ~/.vim/bundle/snippets/snippets/markdown.snippets"
# alias ehs="vi ~/.vim/bundle/snippets/snippets/html.snippets"
alias filetree="ls -R | grep ":$" | sed -e 's/:$//' -e 's/[^-][^\/]*\//--/g' -e 's/^/ /' -e 's/-/|/'"
alias rm="rm -f"
alias ds="du -hs * | sort -h"
alias isaid="sudo"
alias fucking="sudo"
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
# alias ll="ls -al | more"
alias ..="cd .."
alias su="sudo su"
alias root="sudo su"


alias dtrace1="sudo dtrace -n 'syscall::open:entry{trace(execname);}'"
alias wifimon="open \"/System/Library/CoreServices/Wi-Fi Diagnostics.app\""
alias profile="atom ~/.zsh_profile"
alias dev="cd ~/Dropbox/Development/"

# dev stuff
alias g='bundle exec guard'
alias subl='atom'
alias st='subl'
alias mate='subl'
alias sourceme='source ~/.bash_profile'
alias spoof="sudo spoof randomize en1" # see https://github.com/feross/spoof





echo 'Login and run command complete'
echo

test -e "${HOME}/.iterm2_shell_integration.bash" && source "${HOME}/.iterm2_shell_integration.bash"

# Starling Bank AWS additions
source /Users/rob/.aws/starling-additions/functions.sh
