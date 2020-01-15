#!/bin/zsh

################################################################################
# Install fonts

echo ""
echo "Installing Powerline fonts ..."
mkdir -p "${ZDOTDIR:-$HOME}/Library/Fonts"
if [[ ! -f "${ZDOTDIR:-$HOME}/Library/Fonts/Meslo LG M Regular for Powerline.ttf" ]]; then
  git clone https://github.com/powerline/fonts.git --depth=1 powerline_fonts
  ./powerline_fonts/install.sh
  rm -rf powerline_fonts
else
  echo "... fonts already installed (skipping)"
fi

# Atom font
# 12pt Meslo LG M Regular for Powerline

# iTerm2 font
# 12pt Meslo LG M Regular for Powerline
# Anti-aliased
# Use thin strokes for anti-aliased text: Always
