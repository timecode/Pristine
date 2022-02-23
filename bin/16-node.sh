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
if [ ! -z ${DISABLE_NVM_NODE_UPDATES} ]; then
  echo
  echo "Checking latest available node version ..."
  current_node=$(nvm current)
  latest_node=$(nvm ls-remote | tail -n 1 | sed -E 's/^.*(v[0-9.]*).*/\1/')

  if [[ "${current_node}" != "${latest_node}" ]]; then
      echo "\e[33mNew node version available (${latest_node} > ${current_node}) ...\e[39m"
      >&2 echo "\e[33m... UPDATING CURRENTLY DISABLED\e[39m"
  fi

  return

fi

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
