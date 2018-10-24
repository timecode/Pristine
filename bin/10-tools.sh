#!/bin/zsh

scriptDirectory=$(exec 2>/dev/null; cd -- $(dirname "$0"); /usr/bin/pwd || /bin/pwd || pwd)
. $scriptDirectory/../conf/node/helpers.sh
. $scriptDirectory/../conf/brew/helpers.sh

################################################################################
# Install software

#####################################
# mac OS
#####################################

echo ""
if type "brew" > /dev/null; then
  echo "Homebrew already installed :-)"
  if ! [ -d /usr/local/Frameworks ]; then
    echo "... need to add missing dir '/usr/local/Frameworks'"
    sudo mkdir -p /usr/local/Frameworks
    sudo chown $(whoami):admin /usr/local/Frameworks
  fi
else
  # /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
  # /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/uninstall)"
  echo "Please install Homebrew first..."
  echo "... find it here: https://brew.sh/"
  echo ""
  exit 1
fi

######################################
# nvm and node
echo ""
echo "Checking nvm, node, npm status..."

if [ -f /usr/local/bin/npm ]; then
  echo "... removing non-nvm installed npm..."
  rm /usr/local/bin/npm
fi

if [ -d $HOME/.nvm ]; then
  echo "... a version of nvm is already installed"
else
  echo "... installing nvm"
  echo ""
  # https://github.com/creationix/nvm
  curl -o- https://raw.githubusercontent.com/creationix/nvm/master/install.sh | bash
  # wget -qO- https://raw.githubusercontent.com/creationix/nvm/master/install.sh | bash
fi

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm

echo ""
echo "Ensuring latest node..."
if ($( brew uninstall --ignore-dependencies node >/dev/null 2>&1 )) ; then
  echo "Removed brew's install of node!"
fi
nvm install node
nvm install-latest-npm
npm config delete prefix
nvm use stable

# list currently installed package versions
node_installed_packages_list

echo ""
echo "Checking for uninstalled packages..."

declare -a my_essential_node_packages=(
  spoof
  http-server
)
node_install_packages "${my_essential_node_packages[@]}"

# ######################################
# brew
echo ""
echo "Checking Homebrew state..."
brew update
brew --version

# check brew health
brew doctor
brew cask doctor
# check for upgrades
# Homebrew automatically taps and keeps Homebrew-Cask updated. brew update is all that is required.
brew upgrade
brew cask upgrade
# tidy symlinks
brew prune

# list currently installed versions
brew_installed_bottles_list
brew_installed_casks_list

echo ""
echo "Checking for uninstalled dependencies..."

declare -a my_essential_bottles=(
  lesspipe
  git
  gpg-agent
  tree
  jq
  ncdu
  nmap
  wget
  tmux
  tor
  stow
)
brew_install_bottles "${my_essential_bottles[@]}"

declare -a my_essential_casks=(
  github
  macdown
  shiftit
  insomnia
)
brew_install_casks ${my_essential_casks[@]}
# brew cask upgrade ${my_essential_casks[@]}

declare -a language_bottles=(
  python@2
  python       # now the default for python@3
  pipenv
  rbenv
  go
  yarn
)
brew_install_bottles "${language_bottles[@]}"

declare -a language_casks=(
  java
)
brew_install_casks ${language_casks[@]}
# brew cask upgrade ${language_casks[@]}

declare -a work_bottles=(
  awscli
  packer
  gradle
  jfrog-cli-go
  coreos-ct
  openresty
)
brew_install_bottles "${work_bottles[@]}"

declare -a work_casks=(
  virtualbox
  vagrant
  ngrok
  docker-toolbox
)
brew_install_casks "${work_casks[@]}"

# remove unused brew archives
echo ""
echo "Tidying brew state..."
brew cleanup

######################################
# python installs
echo ""
echo "Setting up python 2 environment..."
pip2 install -U           \
  pip                     \
  virtualenv              \
  virtualenvwrapper       \
  autopep8
echo ""
echo "Setting up python 3 environment..."
pip3 install -U           \
  pip                     \
  virtualenv              \
  virtualenvwrapper       \
  autopep8

echo ""
echo "Installing system python modules..."
pip install -U \
  speedtest-cli

#####################################
# Linux
#####################################

# apt install zsh
# apt install git
