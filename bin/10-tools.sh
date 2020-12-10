#!/usr/bin/env zsh

SCRIPTS_PATH="$(cd "$(dirname "${0}")" >/dev/null 2>&1 || exit ; pwd -P)/.."
# shellcheck source=/dev/null
. "${SCRIPTS_PATH}/conf/brew/helpers.sh"

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
# To `brew update` first run:
#   git -C "/usr/local/Homebrew/Library/Taps/homebrew/homebrew-cask" fetch --unshallow
# This restriction has been made on GitHub's request because updating shallow
# clones is an extremely expensive operation due to the tree layout and traffic of
# Homebrew/homebrew-cask. We don't do this for you automatically to avoid
# repeatedly performing an expensive unshallow operation in CI systems (which
# should instead be fixed to not use shallow clones). Sorry for the inconvenience!
shallow_clone=$(git -C "/usr/local/Homebrew/Library/Taps/homebrew/homebrew-core" rev-parse --is-shallow-repository)
if [ "${shallow_clone}" = "true" ]; then
  >&2 echo "\e[33m"
  >&2 echo "... need to fetch unshallow copy of Homebrew/homebrew-cask ..."
  git -C "/usr/local/Homebrew/Library/Taps/homebrew/homebrew-core" fetch --unshallow
  >&2 echo "... unshallow fetch complete ..."
  >&2 echo "\e[39m"
fi
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
)
#   java  # using openjdk now
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
)
# google-cloud-sdk  # insists on reinstalling everything each time, regardless of updates, so removing for now!
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

required="cloudflared"
install_check=$(command -v ${required})
if [ $? -ne 0 ]; then
  >&2 echo "\e[33m"
  >&2 echo "... initial manual install required for '${required}' ..."
  >&2 echo "$ brew install cloudflare/cloudflare/cloudflared"
  >&2 echo "\e[39m"
fi
required="openresty"
install_check=$(command -v ${required})
if [ $? -ne 0 ]; then
  >&2 echo "\e[33m"
  >&2 echo "... initial manual install required for '${required}' ..."
  >&2 echo "$ brew install openresty/brew/openresty"
  >&2 echo "\e[39m"
fi
required="tfswitch"
install_check=$(command -v ${required})
if [ $? -ne 0 ]; then
  >&2 echo "\e[33m"
  >&2 echo "... initial manual install required for '${required}' ..."
  >&2 echo "$ brew install warrensbox/tap/tfswitch"
  >&2 echo "\e[39m"
fi

# remove unused brew archives
echo
echo "Tidying brew state..."
brew cleanup

#####################################
# Linux
#####################################

# apt install zsh
# apt install git
