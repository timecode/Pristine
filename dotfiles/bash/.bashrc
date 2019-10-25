# tmux check for shell type (if not a login shell, on os x source ~/.bash_profile)
shopt -q login_shell && SHELL_TYPE=1 || SHELL_TYPE=0
if [ $SHELL_TYPE -eq 0 ] ; then
   # echo 'Not a login shell'
   if [ -f $HOME/.bash_profile ]; then
      . $HOME/.bash_profile
   fi
fi

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
