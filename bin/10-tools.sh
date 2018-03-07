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
  echo "Updating brew ..."
  brew update
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

#####################################
# Linux
#####################################

# apt install zsh
# apt install git
