#!/bin/zsh

################################################################################
# Install fonts

echo ""
echo "Setting up initial 'dot' files ..."

#####################################
# Copy zshrc to home
cp ./zshrc "${ZDOTDIR:-$HOME}"/.zshrc

#####################################
# Copy tmux.conf to home
cp ./tmux.conf "${ZDOTDIR:-$HOME}"/.tmux.conf

#####################################
# Copy vimrc to home
# cp ./vimrc ../.vimrc
