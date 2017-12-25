# tmux check for shell type (if not a login shell, on os x source ~/.bash_profile)
shopt -q login_shell && SHELL_TYPE=1 || SHELL_TYPE=0
if [ $SHELL_TYPE -eq 0 ] ; then
   # echo 'Not a login shell'
   if [ -f $HOME/.bash_profile ]; then
      source $HOME/.bash_profile
   fi
fi
