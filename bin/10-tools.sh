#!/usr/bin/env zsh

SCRIPTS_PATH="$(cd "$(dirname "${0}")" >/dev/null 2>&1 || exit ; pwd -P)/.."
# shellcheck source=/dev/null
. "${SCRIPTS_PATH}/conf/brew/helpers.sh"
# shellcheck source=/dev/null
. "${SCRIPTS_PATH}/conf/python/helpers.sh"
# shellcheck source=/dev/null
. "${SCRIPTS_PATH}/conf/node/helpers.sh"

#####################################
# ensure zsh dir is secure!
[ -e /usr/local/share/zsh ] && chmod -R 755 /usr/local/share/zsh

################################################################################
# Install software

#####################################
# mac OS
#####################################

echo
if type "brew" > /dev/null; then
  echo "Homebrew already installed :-)"
  if ! [ -d /usr/local/Frameworks ]; then
    echo "... need to add missing dir '/usr/local/Frameworks'"
    sudo mkdir -p /usr/local/Frameworks
    sudo chown "$(whoami):admin" /usr/local/Frameworks
  fi
else
  # /bin/zsh -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)"
  # /bin/zsh -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/uninstall.sh)"
  # brew remove --force $(brew list --formula)
  # brew remove --force $(brew list --cask)
  echo "Please install Homebrew first..."
  echo "... find it here: https://brew.sh/"
  echo
  exit 1
fi

# ######################################
# brew
echo
echo "Checking Homebrew state..."
brew update
brew --version

# check brew health
brew doctor --verbose

# list currently installed versions
brew_installed_bottles_list
brew_installed_casks_list

echo
echo "Checking for upgrades..."
brew_upgrade_bottles
# echo
# echo "Checking for cask upgrades..."
# brew_upgrade_casks

echo
echo "Adding aws/tap..."

brew tap aws/tap

echo
echo "Checking for uninstalled dependencies..."

declare my_essential_casks=(
  1password-cli
  iterm2
  visual-studio-code
  atom
  github
  macdown
  shiftit
  insomnia
  qlmarkdown
  qlstephen
  qlcolorcode
  quicklook-json
  qlvideo
  betterzip
)
brew_install_casks "${my_essential_casks[@]}"
# brew cask upgrade "${my_essential_casks[@]}"

# setup qlcolorcode defaults
defaults delete org.n8gray.QLColorCode
defaults write org.n8gray.QLColorCode pathHL /usr/local/bin/highlight
defaults write org.n8gray.QLColorCode textEncoding UTF-16
defaults write org.n8gray.QLColorCode webkitTextEncoding UTF-16
defaults write org.n8gray.QLColorCode font "Menlo"
defaults write org.n8gray.QLColorCode fontSizePoints 10
defaults write org.n8gray.QLColorCode hlTheme zenburn
defaults write org.n8gray.QLColorCode extraHLFlags "--line-numbers"
qlmanage -r >/dev/null 2>&1

declare my_essential_bottles=(
  cloudflared
  openssl@1.1
  lesspipe
  git
  gnupg
  tree
  jq
  yq
  ncdu
  nmap
  wget
  tmux
  tor
  stow
  syncthing
  shellcheck
)
brew_install_bottles "${my_essential_bottles[@]}"

declare language_casks=(
#   java  # using openjdk now
)
brew_install_casks "${language_casks[@]}"
# brew cask upgrade "${language_casks[@]}"

declare language_bottles=(
  # python@3.8
  python@3.9
  rbenv
  go
  yarn
  nodeenv
  openjdk
  kotlin
  ktlint
)
brew_install_bottles "${language_bottles[@]}"

declare work_casks=(
  virtualbox
  vagrant
  ngrok
  docker-toolbox
  pgadmin4
  # google-cloud-sdk  # insists on reinstalling everything each time, regardless of updates, so removing for now!
)
brew_install_casks "${work_casks[@]}"

declare work_bottles=(
  docker-credential-helper
  kite
  wireguard-tools
  qrencode
  # zbar
  awscli
  minikube
  kubernetes-cli
  packer
  gradle
  jfrog-cli
  aws-sam-cli
)
brew tap mongodb/brew
brew_install_bottles "${work_bottles[@]}"

required="openresty"
install_check=$(command -v ${required})
if [ $? -ne 0 ]; then
  echo
  echo "... initial manual install required for '${required}' ..."
  echo "$ brew install openresty/brew/openresty"
fi
required="tfswitch"
install_check=$(command -v ${required})
if [ $? -ne 0 ]; then
  echo
  echo "... initial manual install required for '${required}' ..."
  echo "$ brew install warrensbox/tap/tfswitch"
fi

# remove unused brew archives
echo
echo "Tidying brew state..."
brew cleanup

######################################
# python installs

echo
# echo "Forcing python3.8 to be default..."
# ln -fs /usr/local/bin/python3.8 /usr/local/bin/python
# ln -fs /usr/local/bin/pip3 /usr/local/bin/pip
echo "Forcing python3.9 to be default..."
ln -fs /usr/local/opt/python@3.9/bin/python3 /usr/local/bin/python
ln -fs /usr/local/opt/python@3.9/bin/pip3 /usr/local/bin/pip

echo
echo "Setting up python environment..."
pip_install pip setuptools

echo
echo "Installing system python modules..."
declare my_essential_python_modules=(
  pipenv
  autopep8
)
pip_install "${my_essential_python_modules[@]}"

declare my_system_python_modules=(
  speedtest-cli
)
pip_install "${my_system_python_modules[@]}"

######################################
# nvm and node
echo
echo "Checking nvm, node, npm status..."

if [ -f /usr/local/bin/npm ]; then
  echo "... removing non-nvm installed npm..."
  rm -f /usr/local/bin/npm
fi

ensure_latest_nvm

ensure_latest_node

# list currently installed package versions
echo "Checking currently installed node packages ..."
# npm_global_installed_packages_list
yarn_global_installed_packages_list

echo
echo "Upgrading global node packages ..."
# npm -g upgrade
yarn global upgrade --silent

declare my_essential_node_packages=(
  node-gyp
  spoof
  nodemon
)
# npm_global_install_packages "${my_essential_node_packages[@]}"
yarn_global_install_packages "${my_essential_node_packages[@]}"

declare work_node_packages=(
  http-server
  serve
  surge
  create-react-app
  react-static
  amplify
  jest
  serverless
  graphql
  prisma
)
# npm_global_install_packages "${work_node_packages[@]}"
yarn_global_install_packages "${work_node_packages[@]}"

echo
echo "Checking outdated global node packages ..."
# npm_outdated_global_installed_packages_list
yarn_outdated_global_installed_packages_list

echo
echo "Tidying yarn cache..."
yarn cache clean

echo
echo "Tidying nvm cache..."
nvm cache clear

remove_npm

#####################################
# Linux
#####################################

# apt install zsh
# apt install git
