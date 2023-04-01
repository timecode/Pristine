#!/usr/bin/env zsh

SCRIPTS_PATH="$(cd "$(dirname "${0}")" >/dev/null 2>&1 || exit ; pwd -P)/.."
# shellcheck source=/dev/null
. "${SCRIPTS_PATH}/conf/node/helpers.sh"

######################################
# nvm and node
echo
echo "Checking nvm, node, npm status..."

ensure_latest_nvm
remove_non_nvm_installed_npm

DISABLE_NVM_NODE_UPDATES=true
# uncomment the next line to ENABLE nvm node updates, or just use the following conditional
# unset DISABLE_NVM_NODE_UPDATES

ensure_latest_node

# conditional for node updates
if [ ! -z ${NVM_NODE_UPDATES_AVAILABLE} ]; then
  echo "\e[33m"
  read -q "REPLY?... update now? (y/N) "
  echo "\e[39m"
  if [ $REPLY = "y" ]; then
    # echo "\n... yay, updating ..."
    unset DISABLE_NVM_NODE_UPDATES
    ensure_latest_node
  fi
fi

if [ ! -z ${DISABLE_NVM_NODE_UPDATES} ]; then
  return
fi

# list currently installed package versions
echo "Checking currently installed node packages ..."
# npm_global_installed_packages_list
yarn_global_installed_packages_list

echo
echo "Upgrading global node packages ..."
# npm -g upgrade
yarn_global_upgrade_packages

declare node_packages=(

  ### essential packages
  node-gyp
  spoof
  nodemon
  fast-run

  ### work packages
  http-server
  serve
  jest
  graphql
  prisma
  prettier
  wrangler
  snyk
  # ganache
  # truffle

)
# npm_global_install_packages "${node_packages[@]}"
yarn_global_install_packages "${node_packages[@]}"

echo
echo "Checking outdated global node packages ..."
# npm_outdated_global_installed_packages_list
yarn_outdated_global_installed_packages_list

echo
echo "Tidying yarn cache..."
yarn_cache_clean_global
# pushd $HOME && yarn cache clean && popd >/dev/null 2>&1

echo
echo "Tidying nvm cache..."
nvm cache clear

# remove_npm
