#!/usr/bin/env zsh

##############################################################################
### nvm ######################################################################
##############################################################################

ensure_latest_nvm() {
  unset latest
  current="unknown"
  if [ -d "${HOME}/.nvm" ]; then
    echo "... a version of nvm is already installed"
    # check it's up-to-date
    current=$(grep -hnr '"version":' "${HOME}/.nvm/package.json" | sed -E 's/.*: "(.*)".*/\1/')
    latest=$(git ls-remote --tags https://github.com/nvm-sh/nvm.git | cut -d/ -f3- | sort -t. -nk1,2 -k2 | awk '/^[^{]*$/{version=$1}END{print version}' | sed s/v//g)
  fi

  if [ "${current}" != "${latest}" ]; then
    echo "... installing latest nvm"
    echo
    # https://github.com/nvm-sh/nvm
    curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/master/install.sh | bash
    # wget -qO- https://raw.githubusercontent.com/nvm-sh/nvm/master/install.sh | bash
  fi

  nvm_dir="${HOME}/.nvm"
  # shellcheck source=/dev/null
  [ -e "${nvm_dir}/nvm.sh" ] && . "${nvm_dir}/nvm.sh"  # This loads nvm
}

##############################################################################
### node #####################################################################
##############################################################################

ensure_latest_node() {

  NODE_LTS_VERSION=16
  NODE_STABLE=stable

  echo
  echo "Updating node..."
  if brew uninstall --ignore-dependencies node >/dev/null 2>&1 ; then
    rm -rf $BREW_DIR/lib/node_modules/
    echo "Removed brew's install of node!"
  fi

  echo
  echo "Ensuring latest lts node ..."
  nvm use ${NODE_LTS_VERSION} >/dev/null 2>&1
  previous_node_lts=$(nvm current | tail -n 1 | sed -E 's/^.*(v[0-9.]*).*/\1/')
  nvm install ${NODE_LTS_VERSION}
  current_node_lts=$(nvm current | tail -n 1 | sed -E 's/^.*(v[0-9.]*).*/\1/')
  corepack enable

  echo
  echo "Ensuring latest node..."
  nvm use ${NODE_STABLE} >/dev/null 2>&1
  previous_node=$(nvm current | tail -n 1 | sed -E 's/^.*(v[0-9.]*).*/\1/')
  nvm install ${NODE_STABLE}
  current_node=$(nvm current | tail -n 1 | sed -E 's/^.*(v[0-9.]*).*/\1/')
  corepack enable

  echo
  echo "Currently installed node versions..."
  nvm ls
  echo
  echo "To remove previous node versions..."
  echo "$ nvm uninstall <version>"
  if [[ "${previous_node_lts}" != "${current_node_lts}" ]]; then
      echo "\e[33mnvm uninstall ${previous_node_lts}\e[39m"
  fi
  if [[ "${previous_node}" != "${current_node}" ]]; then
      echo "\e[33mnvm uninstall ${previous_node}\e[39m"
  fi
  echo
}

##############################################################################
### npm ######################################################################
##############################################################################

remove_non_nvm_installed_npm() {
  if [ -f /usr/local/bin/npm ]; then
    echo "... removing non-nvm installed npm..."
    echo $(which npm)
    rm -f /usr/local/bin/npm
  fi
  if [ -f $BREW_DIR/bin/npm ]; then
    echo "... removing non-nvm installed npm..."
    rm -f $BREW_DIR/bin/npm
  fi
}

remove_npm() {
  echo
  echo "Checking for npm ..."
  if npm --version >> /dev/null 2>&1 ; then
    echo "... removing npm ..."
    sh -c "rm -rf ${HOME}/.nvm/versions/node/*/{lib/node{,/.npm,_modules},bin,share/man}/npm*"
    sh -c "rm -rf /usr/local/{lib/node{,/.npm,_modules},bin,share/man}/npm*"
    echo "... to get npm back ..."
    echo "... nvm install <node version>"
  else
    echo "... npm not installed"
  fi
}

npm_global_installed_packages() {
  local installed=()
  IFS=' '; while read -r l; do installed+=( "${l}" ); done < <(npm list -g --depth=0 --json | jq ".dependencies" | jq -r 'keys[]')
  unset IFS
  local gloably_installed=()
  for element in "${installed[@]}"; do
    gloably_installed+=("$(basename "${element}")")
  done
  echo "${gloably_installed[*]}"
}

npm_global_installed_packages_list() {
  local installed=()
  while read -r -d $' ' l; do installed+=( "${l}" ); done < <(echo "$(npm_global_installed_packages) ")
  if [ ${#installed[@]} -gt 0 ]; then
    echo
    echo "Currently installed npm global packages..."
    for element in "${installed[@]}"; do
      echo "${element}"
    done
  fi
}

npm_outdated_global_installed_packages() {
  local arr=("$(npm outdated -g --depth=0 --parseable --json | jq -r 'keys[]')")
  local gloably_outdated_installed=()
  for element in "${arr[@]}"; do
    gloably_outdated_installed+=("$(basename "${element}")")
  done
  echo "${gloably_outdated_installed[*]}"
}

npm_global_install_packages() {
  local install=("${@}")
  local to_install=()
  local installed=()
  local i=0
  while read -r -d $' ' l; do installed+=( "${l}" ); done < <(echo "$(npm_global_installed_packages) ")

  len="${#install[@]}"
  if [ "${len}" -gt 0 ]; then
    local marker='INSTALLED'
    for target in "${installed[@]}"; do
      for (( i=1; i<=len; i++ )); do
        if [[ "${install[${i}]}" = "${target}" ]]; then
          install[i]="${marker}"
          break
        fi
      done
    done
    for (( i=1; i<=len; i++ )); do
      if [[ "${install[${i}]}" != "${marker}" ]]; then
        to_install+=("${install[${i}]}")
      fi
    done
  fi

  if [ "${#to_install[@]}" -gt 0 ]; then
    local sorted_install=()
    IFS=$'\n' sorted_install=("$(sort <<<"${to_install[*]}")")
    unset IFS
    to_install=()
    while read -r l; do to_install+=( "${l}" ); done < <(echo "${sorted_install[*]}")

    # install uninstalled
    echo
    echo "Installing global node packages..."
    echo "${to_install[@]}"
    npm -g install "${to_install[@]}"
  fi
}

npm_outdated_global_installed_packages_list() {
  local arr=()
  while read -r -d $' ' l; do arr+=( "${l}" ); done < <(echo "$(npm_outdated_global_installed_packages) ")
  echo "npm outdated ..."
  for element in "${arr[@]}"; do
    echo "${element}"
  done
}

##############################################################################
### yarn #####################################################################
##############################################################################

yarn_global_installed_packages() {
  local installed=()
  while read -r l; do installed+=( "${l}" ); done < <(pushd "$(yarn_global_dir)" && yarn global list --no-progress && popd >/dev/null 2>&1)
  unset IFS
  local gloably_installed=()
  regex="^- \w*"
  for element in "${installed[@]}"; do
    if [[ "${element}" =~ ${regex} ]]; then
      gloably_installed+=("${element/- /}")
    fi
  done
  echo "${gloably_installed[@]}"
}

yarn_global_installed_packages_list() {
  local installed=()
  while read -r -d $' ' l; do installed+=( "${l}" ); done < <(echo "$(yarn_global_installed_packages) ")
  if [ ${#installed[@]} -gt 0 ]; then
    echo
    echo "Currently installed yarn global packages..."
    for element in "${installed[@]}"; do
      echo "${element}"
    done
  fi
}

yarn_global_install_packages() {
  local install=("${@}")
  local to_install=()
  local installed=()
  local i=0
  while read -r -d $' ' l; do installed+=( "${l}" ); done < <(echo "$(yarn_global_installed_packages) ")

  len="${#install[@]}"
  if [ "${len}" -gt 0 ]; then
    local marker='INSTALLED'
    for target in "${installed[@]}"; do
      for (( i=1; i<=len; i++ )); do
        if [[ "${install[${i}]}" = "${target}" ]]; then
          install[i]="${marker}"
          break
        fi
      done
    done
    for (( i=1; i<=len; i++ )); do
      if [[ "${install[${i}]}" != "${marker}" ]]; then
        to_install+=("${install[${i}]}")
      fi
    done
  fi

  if [ "${#to_install[@]}" -gt 0 ]; then
    local sorted_install=()
    IFS=$'\n' sorted_install=("$(sort <<<"${to_install[*]}")")
    unset IFS
    to_install=()
    while read -r l; do to_install+=( "${l}" ); done < <(echo "${sorted_install[*]}")

    # install uninstalled
    echo
    echo "Installing global node packages..."
    echo "${to_install[@]}"
    pushd "$(yarn_global_dir)"
    yarn global add "${to_install[@]}"
    popd >/dev/null 2>&1
  fi
}

yarn_global_dir() {
  pushd $HOME && yarn global dir && popd >/dev/null 2>&1
}

yarn_global_upgrade_packages() {
  pushd "$(yarn_global_dir)"
  yarn global upgrade --silent
  popd >/dev/null 2>&1
}

yarn_outdated_global_installed_packages_list() {
  pushd "$(yarn_global_dir)"
  yarn outdated
  if [ $? -ne 0 ]; then
    >&2 echo "\e[33m"
    >&2 echo "... manually update global packages using ..."
    >&2 echo "$ pushd \$HOME && yarn global upgrade && popd >/dev/null 2>&1"
    >&2 echo "\e[39m"
  fi
  popd >/dev/null 2>&1
}

yarn_cache_clean_global() {
  pushd "$(yarn_global_dir)"
  yarn cache clean
  popd >/dev/null 2>&1
}
