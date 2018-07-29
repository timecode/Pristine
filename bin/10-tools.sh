#!/bin/zsh

################################################################################
# Install software

#####################################
# mac OS
#####################################

echo ""
if type "brew" > /dev/null; then
  echo "Homebrew already installed :-)"
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
echo "Installing nvm, node, npm..."

if [ -f /usr/local/bin/npm ]; then
  echo "Removing non-nvm installed npm..."
  rm /usr/local/bin/npm
fi

if [ -d $HOME/.nvm ]; then
  echo "nvm already installed..."
else
  # https://github.com/creationix/nvm
  curl -o- https://raw.githubusercontent.com/creationix/nvm/v0.33.8/install.sh | bash
  # wget -qO- https://raw.githubusercontent.com/creationix/nvm/v0.33.8/install.sh | bash
fi

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm

echo ""
echo "Installing latest node..."
nvm install node
nvm install-latest-npm
npm config delete prefix
nvm use node

echo ""
echo "Installing node modules..."
npm install spoof -g

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
  openresty

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
brew cask cleanup

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

#####################################
# Linux
#####################################

# apt install zsh
# apt install git
