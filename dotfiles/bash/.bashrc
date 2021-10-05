#!/usr/bin/env bash

# tmux check for shell type (if not a login shell, on os x source ~/.bash_profile)
shopt -q login_shell && SHELL_TYPE=1 || SHELL_TYPE=0
if [ $SHELL_TYPE -eq 0 ] ; then
   # echo 'Not a login shell'
   # shellcheck source=/dev/null
   [ -e "${HOME}/.bash_profile" ] && . "${HOME}/.bash_profile"
fi

export NVM_DIR="$HOME/.nvm"
# shellcheck source=/dev/null
[ -s "${NVM_DIR}/nvm.sh" ] && . "${NVM_DIR}/nvm.sh"  # This loads nvm
# shellcheck source=/dev/null
[ -s "${NVM_DIR}/bash_completion" ] && . "${NVM_DIR}/bash_completion"  # This loads nvm bash_completion

[ -s "${HOME}/.cargo/env" ] && . "${HOME}/.cargo/env"  # This loads cargo
