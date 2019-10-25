#!/bin/zsh

scriptDirectory=$(exec 2>/dev/null; cd -- $(dirname "$0"); /usr/bin/pwd || /bin/pwd || pwd)
. $scriptDirectory/../conf/brew/helpers.sh
. $scriptDirectory/../conf/python/helpers.sh
. $scriptDirectory/../conf/node/helpers.sh

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
brew cask upgrade $(brew_installed_casks)

# list currently installed versions
brew_installed_bottles_list
brew_installed_casks_list

echo ""
echo "Adding aws/tap..."

brew tap aws/tap

echo ""
echo "Checking for uninstalled dependencies..."

declare -a my_essential_casks=(
  1password-cli
  visual-studio-code
  atom
  github
  macdown
  qlcommonmark
  shiftit
  insomnia
)
brew_install_casks ${my_essential_casks[@]}
# brew cask upgrade ${my_essential_casks[@]}

declare -a my_essential_bottles=(
  lesspipe
  git
  gpg-agent
  tree
  jq
  yq
  ncdu
  nmap
  wget
  tmux
  tor
  stow
  openssl@1.1
)
brew_install_bottles "${my_essential_bottles[@]}"

declare -a language_casks=(
  java
)
brew_install_casks ${language_casks[@]}
# brew cask upgrade ${language_casks[@]}

declare -a language_bottles=(
  python
  rbenv
  go
  yarn
  nodeenv
)
brew_install_bottles "${language_bottles[@]}"

declare -a work_casks=(
  virtualbox
  vagrant
  ngrok
  docker-toolbox
  minikube
)
brew_install_casks "${work_casks[@]}"

declare -a work_bottles=(
  kite
  wireguard-tools
  qrencode
  awscli
  kubectl
  packer
  gradle
  jfrog-cli-go
  coreos-ct
  openresty
  aws-sam-cli
  terraform
)
brew_install_bottles "${work_bottles[@]}"

# remove unused brew archives
echo ""
echo "Tidying brew state..."
brew cleanup

######################################
# python installs
declare -a my_essential_python_modules=(
  pipenv
  autopep8
)

echo ""
echo "Setting up python environment..."
pip_install pip setuptools
pip_install "${my_essential_python_modules[@]}"

declare -a my_system_python_modules=(
  speedtest-cli
)

echo ""
echo "Installing system python modules..."
pip_install "${my_system_python_modules[@]}"

echo ""
echo "Forcing python3 to be default..."
ln -fs /usr/local/bin/python3 /usr/local/bin/python
ln -fs /usr/local/bin/pip3 /usr/local/bin/pip

######################################
# nvm and node
echo ""
echo "Checking nvm, node, npm status..."

if [ -f /usr/local/bin/npm ]; then
  echo "... removing non-nvm installed npm..."
  rm -f /usr/local/bin/npm
fi

ensure_latest_nvm

ensure_latest_node

# list currently installed package versions
# npm_global_installed_packages_list
yarn_global_installed_packages_list

declare -a my_essential_node_packages=(
  spoof
)
# npm_global_install_packages "${my_essential_node_packages[@]}"
yarn_global_install_packages "${my_essential_node_packages[@]}"

declare -a work_node_packages=(
  http-server
  serve
  surge
  create-react-app
  react-static
  @aws-amplify/cli
  jest
  serverless
  # graphql # cannot global add (yet)
)
# node_global_install_packages "${work_node_packages[@]}"
yarn_global_install_packages "${work_node_packages[@]}"

yarn_upgrade_global_outdated

# echo ""
# echo "Tidying yarn cache..."
# yarn cache clean

# npm keeps sneaking back in somewhere, so...
remove_npm

#####################################
# Linux
#####################################

# apt install zsh
# apt install git
