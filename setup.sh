#!/bin/zsh
set -e

# Install software

# Linux
# apt install zsh
# apt install git

# mac OS
brew install git

# Install prezto
rm -rf "${ZDOTDIR:-$HOME}/.zprezto"
git clone --recursive https://github.com/sorin-ionescu/prezto.git "${ZDOTDIR:-$HOME}/.zprezto"

# Configure prezto
setopt EXTENDED_GLOB
for rcfile in "${ZDOTDIR:-$HOME}"/.zprezto/runcoms/^README.md(.N); do
  rm "${ZDOTDIR:-$HOME}/.${rcfile:t}"
  ln -s "$rcfile" "${ZDOTDIR:-$HOME}/.${rcfile:t}"
  echo "linking ${rcfile:t}"
done

# Install Powerline fonts
# clone
git clone https://github.com/powerline/fonts.git --depth=1 powerline_fonts
# install
./powerline_fonts/install.sh
# clean-up
rm -rf powerline_fonts

# Atom font
# 12pt Meslo LG M Regular for Powerline

# iTerm2 font
# 12pt Meslo LG M Regular for Powerline
# Anti-aliased
# Use thin strokes for anti-aliased text: Always

# Copy vimrc to home
# cp ./vimrc ../.vimrc

# Copy zshrc to home
cp ./zshrc ../.zshrc

# Change shell to zsh permanently
chsh -s /bin/zsh

# Message

echo ""
echo "OK, now exit this shell and create a new one, and you should be all set."

## PERFORMING UPDATES
# Run this command ...
# $ zprezto-update
# or, pull the latest changes and update submodules manually with:
# $ cd $ZPREZTODIR
# $ git pull && git submodule update --init --recursive
