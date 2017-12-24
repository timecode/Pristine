#!/bin/zsh
set -e

################################################################################
# Install software

# Linux
# apt install zsh
# apt install git

# mac OS
#####################################
echo ""
echo "Installing dependencies ..."
brew install git

#####################################
echo ""
echo "Installing Powerline fonts ..."
if [[ ! -f "${ZDOTDIR:-$HOME}/Library/Fonts/Meslo LG M Regular for Powerline.ttf" ]]; then
  git clone https://github.com/powerline/fonts.git --depth=1 powerline_fonts
  ./powerline_fonts/install.sh
  rm -rf powerline_fonts
else
  echo "... Powerline fonts already installed (skipping)"
fi

# Atom font
# 12pt Meslo LG M Regular for Powerline

# iTerm2 font
# 12pt Meslo LG M Regular for Powerline
# Anti-aliased
# Use thin strokes for anti-aliased text: Always

#####################################
echo ""
echo "Installing Prezto ..."
if [[ -f "${ZDOTDIR:-$HOME}/.zprezto/init.zsh" ]]; then
  source "${ZDOTDIR:-$HOME}/.zprezto/init.zsh" || true
  echo "... Prezto already installed (updating ...)"
  ## PERFORMING UPDATES
  # Run this command ...
  zprezto-update
  # or, pull the latest changes and update submodules manually with:
  # $ cd $ZPREZTODIR
  # $ git pull && git submodule update --init --recursive
else
  if [[ -d "${ZDOTDIR:-$HOME}/.zprezto" ]]; then
    rm -rf "${ZDOTDIR:-$HOME}/.zprezto"
  fi
  echo "Installing Prezto ..."
  git clone --recursive https://github.com/sorin-ionescu/prezto.git "${ZDOTDIR:-$HOME}/.zprezto"
  # Configure prezto
  setopt EXTENDED_GLOB
  for rcfile in "${ZDOTDIR:-$HOME}"/.zprezto/runcoms/^README.md(.N); do
    rm -f "${ZDOTDIR:-$HOME}/.${rcfile:t}"
    ln -s "$rcfile" "${ZDOTDIR:-$HOME}/.${rcfile:t}"
  done
fi


################################################################################
echo ""
echo "Setting up initial 'dot' files ..."

#####################################
# Copy zshrc to home
cp ./zshrc "${ZDOTDIR:-$HOME}"/.zshrc

#####################################
# Copy vimrc to home
# cp ./vimrc ../.vimrc

#####################################
echo ""
echo "Modifying .zpretzorc ..."

sed -i '' "s/zstyle ':prezto:module:prompt' theme 'sorin'/zstyle ':prezto:module:prompt' theme 'paradox'/g" "${ZDOTDIR:-$HOME}/.zpreztorc"

sed -i '' "s/zstyle ':prezto:module:editor' key-bindings 'emacs'/zstyle ':prezto:module:editor' key-bindings 'vi'/g" "${ZDOTDIR:-$HOME}/.zpreztorc"


################################################################################
echo ""
echo "Changing shell to zsh (permanently) ..."
chsh -s /bin/zsh


################################################################################
echo ""
echo "Done! Now exit this shell and create a new one to use the new setup."
