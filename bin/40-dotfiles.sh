#!/bin/zsh

scriptDirectory=$(exec 2>/dev/null; cd -- $(dirname "$0"); /usr/bin/pwd || /bin/pwd || pwd)

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

cat <<EOF > $HOME/.stowrc
--dir=${scriptDirectory}/../dotfiles
--target=$HOME
--ignore=.DS_Store
EOF

#####################################
if [[ -f "${ZDOTDIR:-$HOME}/.zshrc" ]]; then
  echo "... backing-up existing .zshrc ..."
  cp ${ZDOTDIR:-$HOME}/.zshrc ${ZDOTDIR:-$HOME}/.zshrc_bak
  rm -f ${ZDOTDIR:-$HOME}/.zshrc
fi

#####################################
# Add directory/names of apps below to have
# their dotfiles installed by stow during setup
stow -v --stow  \
  stow          \
  bash          \
  pip           \
  zsh           \
  vim           \
  qlmarkdown    \
  tmux          \
  docker

#####################################
# special settings for iterm2
stow -v --stow  \
  iterm2
# specify preferences directory (now under dotfile control)
defaults write com.googlecode.iterm2.plist PrefsCustomFolder -string "~/.iterm2_profile"
# use custom preferences
defaults write com.googlecode.iterm2.plist LoadPrefsFromCustomFolder -bool true
