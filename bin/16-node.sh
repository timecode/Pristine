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
# uncomment the next line to ENABLE nvm node updates
# unset DISABLE_NVM_NODE_UPDATES

ensure_latest_node

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

declare my_essential_node_packages=(
  node-gyp
  spoof
  nodemon
  fast-run
)
# npm_global_install_packages "${my_essential_node_packages[@]}"
yarn_global_install_packages "${my_essential_node_packages[@]}"

declare work_node_packages=(
  http-server
  serve
  surge
  create-react-app
  react
  jest
  graphql
  prisma
  prettier
  wrangler
  snyk
  # ganache
  # truffle
)
# npm_global_install_packages "${work_node_packages[@]}"
yarn_global_install_packages "${work_node_packages[@]}"

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
