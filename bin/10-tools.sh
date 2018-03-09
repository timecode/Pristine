#!/bin/zsh

################################################################################
# Install software

#####################################
# mac OS
#####################################
# /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
# /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/uninstall)"

echo ""
if type "brew" > /dev/null; then
  brew upgrade
  echo "Installing tool dependencies ..."
  brew install    \
    lesspipe      \
    git           \
    awscli        \
    gpg-agent     \
    python        \
    python2       \
    rbenv         \
    yarn          \
    go            \
    tree          \
    jq            \
    ncdu          \
    wget          \
    tmux          \
    tor           \
    stow

  # adns		  gradle		 packer
  # libffi    libusb-compat
  # gmp		    jfrog-cli-go		md5sha1sum
  # cdrtools	gnupg		        p11-kit	    watch
  # coreutils	gnupg2	   kops	    nettle	    p7zip	 webkit2png
  # dirmngr		gnutls	   nmap	    	    redis
  # libtasn1 	npth       ec2-ami-tools  libusb

else
  echo "Please install Homebrew first ..."
  echo "... find it here: https://brew.sh/"
  echo ""
  exit 1
fi

# install latest nvm and node
if [ -d $HOME/.nvm ]; then
  export NVM_DIR="$HOME/.nvm"
  [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
  nvm install-latest-npm
  nvm use node
else
  wget -qO- https://raw.githubusercontent.com/creationix/nvm/v0.33.8/install.sh | bash
fi

nvm install node

# install node modules
npm install spoof -g

#####################################
# Linux
#####################################

# apt install zsh
# apt install git
