#!/bin/zsh

################################################################################
# Install fonts

echo ""
echo "Setting up initial 'dot' files ..."

#####################################
# Copy zshrc to home
cp conf/zshrc "${ZDOTDIR:-$HOME}"/.zshrc

#####################################
# Copy tmux.conf to home
cp conf/tmux.conf.sh "${ZDOTDIR:-$HOME}"/.tmux.conf

#####################################
# Copy vimrc to home
# cp ./vimrc ../.vimrc
