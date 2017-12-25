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

#####################################
# Add directory/names of apps below to have
# their dotfiles installed by stow during setup
stow -v -d dotfiles --target=$HOME --stow \
  bash      \
  tmux
