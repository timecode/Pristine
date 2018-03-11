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

# install latest nvm and node
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

echo ""
echo "Checking Homebrew..."
brew upgrade
brew doctor
echo "Installing tool dependencies..."
brew install          \
  lesspipe            \
  git                 \
  awscli              \
  gpg-agent           \
  python2             \
  python              \
  pipenv              \
  rbenv               \
  go                  \
  tree                \
  jq                  \
  ncdu                \
  wget                \
  tmux                \
  tor                 \
  stow

brew install          \
  yarn --without-node

# adns		  gradle		 packer
# libffi    libusb-compat
# gmp		    jfrog-cli-go		md5sha1sum
# cdrtools	gnupg		        p11-kit	    watch
# coreutils	gnupg2	   kops	    nettle	    p7zip	 webkit2png
# dirmngr		gnutls	   nmap	    	    redis
# libtasn1 	npth       ec2-ami-tools  libusb

# pip3 install --upgrade pip3 setuptools
# pip2 install --upgrade pip2 setuptools

#####################################
# Linux
#####################################

# apt install zsh
# apt install git
