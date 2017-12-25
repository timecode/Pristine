#!/bin/zsh

################################################################################
# Install dotfiles

echo ""
echo "Setting up dotfiles ..."
if ! type "stow" > /dev/null; then
  echo "... installing stow"
  brew install stow
fi

#####################################
echo "... bootstrapping stow"
stow -v -d dotfiles --target=$HOME --stow stow

stow -v -d dotfiles --target=$HOME --stow \
  bash      \
  tmux

# #####################################
# # Copy vimrc to home
# # cp ./vimrc ../.vimrc
