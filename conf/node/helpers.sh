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
    latest=$(git ls-remote --tags git://github.com/creationix/nvm.git | cut -d/ -f3- | sort -t. -nk1,2 -k2 | awk '/^[^{]*$/{version=$1}END{print version}' | sed s/v//g)
  fi

  if [ "${current}" != "${latest}" ]; then
    echo "... installing nvm"
    echo
    # https://github.com/nvm-sh/nvm
    curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/master/install.sh | zsh
    # wget -qO- https://raw.githubusercontent.com/nvm-sh/nvm/master/install.sh | zsh
  fi

  nvm_dir="${HOME}/.nvm"
  # shellcheck source=/dev/null
  [ -e "${nvm_dir}/nvm.sh" ] && . "${nvm_dir}/nvm.sh"  # This loads nvm
}

##############################################################################
### node #####################################################################
##############################################################################

ensure_latest_node() {
  echo
  echo "Updating node..."
  if brew uninstall --ignore-dependencies node >/dev/null 2>&1 ; then
    echo "Removed brew's install of node!"
  fi

  echo
  echo "Ensuring latest lts/erbium (v12.x) node..."
  nvm install --lts=erbium

  echo
  echo "Ensuring latest node..."
  nvm install node
  # nvm install-latest-npm
  # npm config delete prefix
  nvm use stable >/dev/null 2>&1

  echo
  echo "Currently installed node versions..."
  nvm ls
  echo
  echo "To remove previous node versions..."
  # echo "$ nvm ls"
  echo "$ nvm uninstall <version>"
  echo
}

##############################################################################
### npm ######################################################################
##############################################################################

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
  while read -r l; do installed+=( "${l}" ); done < <(yarn global list --no-progress)
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
    yarn global add "${to_install[@]}"
  fi
}

yarn_outdated_global_installed_packages_list() {
  yarn_global_dir="$(yarn global dir)"
  cd "${yarn_global_dir}" || 0
  yarn outdated
  if [ $? -ne 0 ]; then
    >&2 echo "\e[33m"
    >&2 echo "... manually update global packages using ..."
    >&2 echo "$ yarn global upgrade"
    >&2 echo "\e[39m"
  fi
}
