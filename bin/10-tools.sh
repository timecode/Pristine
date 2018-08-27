#!/bin/zsh

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
nvm install node
nvm install-latest-npm
npm config delete prefix
nvm use stable

echo ""
echo "Installing global node modules..."
npm install -g \
  spoof

######################################
# brew
echo ""
echo "Checking Homebrew..."
brew --version
brew cask --version

# check brew health
brew doctor
brew cask doctor
# check for upgrades
brew upgrade
brew cask upgrade
# tidy symlinks
brew prune

echo ""
echo "Installing tool dependencies..."
brew install              \
  lesspipe                \
  git                     \
  gpg-agent               \
  tree                    \
  jq                      \
  ncdu                    \
  nmap                    \
  wget                    \
  tmux                    \
  tor                     \
  stow

brew install              \
  python@2                \
  python@3                \
  pipenv                  \
  rbenv                   \
  go

declare -a casks=(
  java
)

brew cask install ${casks[@]}
brew cask upgrade ${casks[@]}

brew install              \
  yarn --without-node

brew install              \
  awscli                  \
  packer                  \
  gradle                  \
  jfrog-cli-go            \
  coreos-ct               \
  openresty/brew/openresty

declare -a casks=(
  vagrant
  shiftit
  insomnia
  ngrok
)

brew cask install ${casks[@]}
brew cask upgrade ${casks[@]}

# remove unused brew archives
echo ""
echo "Tidying up brew..."
brew cleanup

######################################
# python installs
echo ""
echo "Installing python 2..."
pip2 install -U           \
  pip                     \
  virtualenv              \
  virtualenvwrapper       \
  autopep8
echo ""
echo "Installing python 3..."
pip3 install -U           \
  pip                     \
  virtualenv              \
  virtualenvwrapper       \
  autopep8

echo ""
echo "Installing system python module..."
pip install -U \
  speedtest-cli

#####################################
# Linux
#####################################

# apt install zsh
# apt install git
