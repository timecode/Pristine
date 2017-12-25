#!/bin/zsh

################################################################################
# Install fonts

echo ""
echo "Setting up initial 'dot' files ..."

#####################################
echo "... copying zshrc"
cp conf/zshrc "${ZDOTDIR:-$HOME}"/.zshrc

#####################################
echo "... copying tmux.conf"
cp conf/tmux.conf.sh "${ZDOTDIR:-$HOME}"/.tmux.conf

#####################################
# Copy vimrc to home
# cp ./vimrc ../.vimrc
