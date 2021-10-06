#!/usr/bin/env zsh

SCRIPTS_PATH="$(cd "$(dirname "${0}")" >/dev/null 2>&1 || exit ; pwd -P)/.."
# shellcheck source=/dev/null
. "${SCRIPTS_PATH}/conf/node/helpers.sh"

######################################
# nvm and node
echo
echo "Checking nvm, node, npm status..."

DISABLE_NVM=true
# uncomment the next line to allow nvm and node setup
# unset DISABLE_NVM
if [ ! -z ${DISABLE_NVM} ]; then
  >&2 echo "\e[33m... DISABLED\e[39m"; return
fi

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
  react
  jest
  graphql
  prisma
  prettier
  @cloudflare/wrangler
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
