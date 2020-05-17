#!/bin/zsh

scriptDirectory=$(exec 2>/dev/null; cd -- $(dirname "$0"); /usr/bin/pwd || /bin/pwd || pwd)

################################################################################
# Install dotfiles

function setup_dotfiles() {
  echo ""
  echo "Setting up dotfiles ..."
  if ! type "stow" > /dev/null; then
    echo "... installing stow"
    brew install stow
  fi
}

function bootstrap_stow() {
  echo "... bootstrapping stow"

  cat <<EOF > $HOME/.stowrc
--dir=${scriptDirectory}/../dotfiles
--target=$HOME
--ignore=.DS_Store
EOF
}

function setup_zshrc() {
  if [[ -f "${ZDOTDIR:-$HOME}/.zshrc" ]]; then
    echo "... backing-up existing .zshrc ..."
    cp ${ZDOTDIR:-$HOME}/.zshrc ${ZDOTDIR:-$HOME}/.zshrc_bak
    rm -f ${ZDOTDIR:-$HOME}/.zshrc
  fi
  stow -v --stow  \
    zsh
}

function setup_docker() {
  if [[ -f "${ZDOTDIR:-$HOME}/.docker/config.json" ]]; then
    echo "... backing-up existing .docker/config.json ..."
    cp ${ZDOTDIR:-$HOME}/.docker/config.json ${ZDOTDIR:-$HOME}/.docker/config_bak.json
    rm -f ${ZDOTDIR:-$HOME}/.docker/config.json
  fi
  stow -v --stow  \
    docker
}

function stow_dotfiles() {
  # Add directory/names of apps below to have
  # their dotfiles installed by stow during setup
  echo "... running stow (general) ..."
  stow -v --stow  \
    stow          \
    bash          \
    pip           \
    vim           \
    tmux          \
    intelliJ
}

function setup_iterm2() {
  echo "... running stow (iterm2) ..."
  # special settings for iterm2
  rm -rf ~/.iterm2_profile/com.googlecode.iterm2.plist
  stow -v --stow  \
    iterm2 && \
  # specify preferences directory (now under dotfile control)
  defaults write com.googlecode.iterm2.plist PrefsCustomFolder -string "~/.iterm2_profile" && \
  # use custom preferences
  defaults write com.googlecode.iterm2.plist LoadPrefsFromCustomFolder -bool true
}

function setup_vscode() {
  # special settings for vscode as config is not dotfile compatible
  # open a vanilla install of vscode
  # install settings-sync
  # https://marketplace.visualstudio.com/items?itemName=Shan.code-settings-sync
  # `shift + alt + D`
  # to download last sync'd settings
}

{ # try
  setup_dotfiles && \
  bootstrap_stow && \
  setup_iterm2 && \
  setup_zshrc && \
  setup_docker && \
  stow_dotfiles && \
  echo "... dotfiles complete"
} || { # catch
  echo ""
  echo "ERROR with dotfiles... see above"
}

exit 0
