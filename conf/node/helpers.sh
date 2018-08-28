function node_installed_packages() {
  local arr=($(npm list -g --depth=0 --parseable))
  local gloably_installed=()
  for element in "${arr[@]}"; do
    gloably_installed+=($(basename ${element}))
  done
  echo ${gloably_installed}
}

function node_outdated_installed__packages() {
  local arr=($(npm outdated -g --depth=0 --parseable))
  local gloably_outdated_installed=()
  for element in "${arr[@]}"; do
    gloably_outdated_installed+=($(basename ${element}))
  done
  echo ${gloably_outdated_installed}
}

function node_installed_packages_list() {
  local installed=($(node_installed_packages))
  if [ ${#installed[@]} -gt 1 ]; then
    echo ""
    echo "Installed packages..."
    npm list -g --depth=0
  fi
}

function node_install_packages() {
  local arr=("$@")
  local installed=($(node_installed_packages))
  local outdated_installed=($(node_outdated_installed__packages))
  local install=()
  for element in "${arr[@]}"; do
    $(for e in "${installed[@]}"; do [[ "${e}" == "${element}" ]] && exit 0; done)
    if [ $? -ne 0 ]; then
      install+=(${element})
    fi
  done
  IFS=$'\n' sorted=($(sort <<<"${install[*]}"))
  unset IFS
  # install uninstalled packages
  if [ ${#sorted[@]} -gt 0 ]; then
    echo ""
    echo "Installing global node packages..."
    npm install -g ${sorted}
  fi

  # update outdated packages
  if [ ${#outdated_installed[@]} -gt 0 ]; then
    echo ""
    echo "Updating global node packages..."
    npm update -g
  fi
}
