#!/usr/bin/env zsh

INSTALLED_BY_THIS_REPO=()
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

ensure_brew_bin

echo
if type "brew" > /dev/null; then
  echo "Homebrew already installed :-)"
  if ! [ -d $BREW_DIR/Frameworks ]; then
    echo "... need to add missing dir '$BREW_DIR/Frameworks'"
    sudo mkdir -p $BREW_DIR/Frameworks
    sudo chown "$(whoami):admin" $BREW_DIR/Frameworks
  fi
else
  # /bin/zsh -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)"
  # /bin/zsh -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/uninstall.sh)"
  # brew remove --force $(brew list --formula)
  # brew remove --force $(brew list --cask)
  # hack to install x86_64 version of brew...
  # arch -x86_64 /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)"
  # alias ibrew='arch -x86_64 /usr/local/Homebrew/bin/brew'
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
#   git -C "/usr/local/Homebrew/Library/Taps/homebrew/homebrew-core" fetch --unshallow
#   git -C "/usr/local/Homebrew/Library/Taps/homebrew/homebrew-cask" fetch --unshallow
# This restriction has been made on GitHub's request because updating shallow
# clones is an extremely expensive operation due to the tree layout and traffic of
# Homebrew/homebrew-core and Homebrew/homebrew-cask. We don't do this for you
# automatically to avoid repeatedly performing an expensive unshallow operation in
# CI systems (which should instead be fixed to not use shallow clones).
# Sorry for the inconvenience!

# Since brew 4.0 Default Tap Cloning has changed and these may no longer be required
if [ -d "$BREW_DIR/Library/Taps/homebrew/" ]; then
  shallow_clone=$(git -C "$BREW_DIR/Library/Taps/homebrew/homebrew-core" rev-parse --is-shallow-repository)
  if [ "${shallow_clone}" = "true" ]; then
    >&2 echo "\e[33m"
    >&2 echo "... need to fetch unshallow copy of Homebrew/homebrew-core ..."
    git -C "$BREW_DIR/Library/Taps/homebrew/homebrew-core" fetch --unshallow
    >&2 echo "... unshallow fetch of Homebrew/homebrew-core complete ..."
    >&2 echo "\e[39m"
  fi
  shallow_clone=$(git -C "$BREW_DIR/Library/Taps/homebrew/homebrew-cask" rev-parse --is-shallow-repository)
  if [ "${shallow_clone}" = "true" ]; then
    >&2 echo "\e[33m"
    >&2 echo "... need to fetch unshallow copy of Homebrew/homebrew-cask ..."
    git -C "$BREW_DIR/Library/Taps/homebrew/homebrew-cask" fetch --unshallow
    >&2 echo "... unshallow fetch of Homebrew/homebrew-cask complete ..."
    >&2 echo "\e[39m"
  fi
fi

# shellcheck source=path/to/file

brew update 1>/dev/null
brew --version

# check brew health
brew doctor --verbose

# remove unneeded formulae
echo
echo "Checking required formulae state..."
brew autoremove
# NOTE: list all formulae and any dependencies with:
# brew list | while read cask; do echo -n "\e[1;34m$cask ->\e[0m"; brew deps $cask | awk '{printf(" %s ", $0)}'; echo ""; done

# list currently installed versions
brew_installed_bottles_list
brew_installed_casks_list

# show known outdated components
echo
echo "Checking for outdated components..."
>&2 echo -n "\e[34m"
brew outdated
>&2 echo -n "\e[39m"

declare brew_upgrade_skip_list=(
  # add bottles or casks that, for whatever reason, require updates to be skipped
  # ngrok               # pinned to 'latest'
  # quicklook-json      # pinned to 'latest'
)
if ((MAC_OS_VER < 11)); then
  requiresOSupgrade=(
    hammerspoon
    qlcolorcode
    qlmarkdown
  )
  brew_upgrade_skip_list=(${brew_upgrade_skip_list[@]} ${requiresOSupgrade[@]})
fi
echo
echo "Checking for upgrades..."
brew_upgrade_bottles
echo
echo "Checking for cask upgrades..."
brew_upgrade_casks

echo
echo "Adding aws/tap..."
brew tap aws/tap

echo
echo "Checking for uninstalled dependencies..."

declare my_essential_casks=(
  iterm2
  macdown
  insomnia
  qlstephen
  quicklook-json
  qlvideo
)
if ((MAC_OS_VER >= 11)); then
  requiresOSupgrade=(
    visual-studio-code
    github
    hammerspoon   # shiftit replacement https://github.com/peterklijn/hammerspoon-shiftit
    qlcolorcode
    qlmarkdown
  )
  my_essential_casks=(${my_essential_casks[@]} ${requiresOSupgrade[@]})
fi
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
  openssl@3
  lesspipe
  git
  gnupg
  tree
  jq
  nmap
  curl
  wget
  tmux
  tor
  obfs4proxy
  stow
  syncthing
  # shellcheck
  watch
  cloudflared
)
if ((MAC_OS_VER >= 11)); then
  requiresOSupgrade=(
    yq
    ncdu
    mas
  )
  my_essential_bottles=(${my_essential_bottles[@]} ${requiresOSupgrade[@]})
fi
brew_install_bottles "${my_essential_bottles[@]}"

declare language_casks=(
  temurin
  # java  # using temurin now
)
brew_install_casks "${language_casks[@]}"
# brew cask upgrade "${language_casks[@]}"

declare language_bottles=(
  python@3.12 # also, update PYTHON_VERSION in `15-python.sh` to match
  pipx
  rbenv
  go
  # yarn # use corepack enabled version
  nodeenv
  # openjdk # using cask temurin now
  # kotlin
  # ktlint
)
if ((MAC_OS_VER >= 11)); then
  requiresOSupgrade=(
      rustup-init
      # tinygo
  )
  language_bottles=(${language_bottles[@]} ${requiresOSupgrade[@]})
fi
# brew tap tinygo-org/tools
brew_install_bottles "${language_bottles[@]}"

declare work_casks=(
  # virtualbox
  vagrant
  ngrok
  # docker-toolbox
  # pgadmin4
)
# google-cloud-sdk  # insists on reinstalling everything each time, regardless of updates, so removing for now!
brew_install_casks "${work_casks[@]}"

declare work_bottles=(
  docker-credential-helper
  # wireguard-tools
  qrencode
  # zbar
  # awscli
  # aws-sam-cli
  # minikube
  # kubernetes-cli
  # packer
  # gradle
  # jfrog-cli
)
brew tap mongodb/brew
brew_install_bottles "${work_bottles[@]}"

# disabled - trying our "Cloudflare for Teams"
# required="cloudflared"
# INSTALLED_BY_THIS_REPO+=("cloudflared")
# install_check=$(command -v ${required})
# if [ $? -ne 0 ]; then
#   >&2 echo "\e[33m"
#   >&2 echo "... initial manual install required for '${required}' ..."
#   >&2 echo "$ brew install cloudflare/cloudflare/cloudflared"
#   >&2 echo "\e[39m"
# fi
required="openresty"
INSTALLED_BY_THIS_REPO+=("openresty/brew/openresty")
install_check=$(command -v ${required})
if [ $? -ne 0 ]; then
  >&2 echo "\e[33m"
  >&2 echo "... initial manual install required for '${required}' ..."
  >&2 echo "$ brew install openresty/brew/openresty"
  >&2 echo "\e[39m"
fi
required="tfswitch"
INSTALLED_BY_THIS_REPO+=("warrensbox/tap/tfswitch")
install_check=$(command -v ${required})
if [ $? -ne 0 ]; then
  >&2 echo "\e[33m"
  >&2 echo "... initial manual install required for '${required}' ..."
  >&2 echo "$ brew install warrensbox/tap/tfswitch"
  >&2 echo "\e[39m"
fi

# remove unused brew archives (older than 5 days)
echo
echo "Tidying brew state..."
brew cleanup --prune=5
# Note: the cache can be blown away entirely with:
# rm -rf $(brew --cache)

show_brew_installs_not_installed_by_this_repo

#####################################
# Linux
#####################################

# apt install zsh
# apt install git
