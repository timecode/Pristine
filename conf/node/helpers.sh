##############################################################################
### nvm ######################################################################
##############################################################################

function ensure_latest_nvm() {
  install_nvm=0
  if [ -d $HOME/.nvm ]; then
    echo "... a version of nvm is already installed"

    # check it's up-to-date
    current=$(grep -hnr '"version":' $HOME/.nvm/package.json | sed -E 's/.*: "(.*)".*/\1/')
    latest=$(git ls-remote --tags git://github.com/creationix/nvm.git | cut -d/ -f3- | sort -t. -nk1,2 -k2 | awk '/^[^{]*$/{version=$1}END{print version}' | sed s/v//g)
    if [[ ${current} != ${latest} ]]; then
      echo "... updating nvm"
      echo ""
      install_nvm=1
    fi
  else
    echo "... installing nvm"
    echo ""
    install_nvm=1
  fi

  if [ ${install_nvm} -eq 1 ]; then
    # https://github.com/creationix/nvm
    curl -o- https://raw.githubusercontent.com/creationix/nvm/master/install.sh | bash
    # wget -qO- https://raw.githubusercontent.com/creationix/nvm/master/install.sh | bash
  fi

  export NVM_DIR="$HOME/.nvm"
  [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
}

##############################################################################
### node #####################################################################
##############################################################################

function remove_npm() {
  echo ""
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

function ensure_latest_node() {
  echo ""
  echo "Ensuring latest node..."
  if ($( brew uninstall --ignore-dependencies node >/dev/null 2>&1 )) ; then
    echo "Removed brew's install of node!"
  fi
  nvm install node
  # nvm install-latest-npm
  # npm config delete prefix
  nvm use stable >/dev/null 2>&1
  remove_npm

  nvm ls
  echo ""
  echo "To remove previous node versions..."
  # echo "$ nvm ls"
  echo "$ nvm uninstall <version>"
}

##############################################################################
### npm ######################################################################
##############################################################################

function npm_global_installed_packages() {
  local arr=($(npm list -g --depth=0 --parseable))
  local gloably_installed=()
  for element in "${arr[@]}"; do
    gloably_installed+=($(basename ${element}))
  done
  echo ${gloably_installed}
}

function npm_global_installed_packages_list() {
  local installed=($(npm_installed_packages))
  if [ ${#installed[@]} -gt 1 ]; then
    echo ""
    echo "Installed packages..."
    npm list -g --depth=0
  fi
}

function npm_outdated_global_installed_packages() {
  local arr=($(npm outdated -g --depth=0 --parseable))
  local gloably_outdated_installed=()
  for element in "${arr[@]}"; do
    gloably_outdated_installed+=($(basename ${element}))
  done
  echo ${gloably_outdated_installed}
}

function npm_global_install_packages() {
  local arr=("$@")
  local installed=($(npm_global_installed_packages))
  local outdated_installed=($(npm_outdated_global_installed_packages))
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

##############################################################################
### yarn #####################################################################
##############################################################################

function yarn_global_installed_packages() {
  local arr=($(yarn global list --no-progress))
  local gloably_installed=()
  regex='^".*"$'
  for element in "${arr[@]}"; do
    if $(expr "${element}" : "${regex}" >> /dev/null 2>&1) ; then
      element=$(echo ${element} | sed -e 's/\"\(.*\)@.*\"/\1/g')
      gloably_installed+=(${element})
    fi
  done
  echo ${gloably_installed}
}

function yarn_global_installed_packages_list() {
  local installed=($(yarn_global_installed_packages))
  if [ ${#installed[@]} -gt 0 ]; then
    echo ""
    echo "Currently installed yarn global packages..."
    for element in "${installed[@]}"; do
      echo "${element}"
    done
  fi
}

function yarn_outdated_global_installed_packages() {
  local gloably_outdated_installed=()
  cd $(yarn global dir)
  IFS=$'\n' lines=( $(yarn outdated) )
  if [[ $? -ne 0 ]]; then
    outdated=0
    regexPackages='^Package.*Current.*'
    regexDone='^Done.*'
    len=${#lines[@]}
    i=0
    while [ $i -le ${len} ]; do
      if $(expr "${lines[${i}]}" : "${regexPackages}" >> /dev/null 2>&1) ; then
        outdated=1
        i=$(( $i + 1 ))
      fi
      if [ $outdated -ne 0 ]; then
        if $(expr "${lines[${i}]}" : "${regexDone}" >> /dev/null 2>&1) ; then
          outdated=0
        else
          package="$(echo ${lines[${i}]} | cut -d' ' -f1)"
          gloably_outdated_installed+=(${package})
        fi
      fi
      i=$(( $i + 1 ))
    done
  fi
  unset IFS
  echo ${gloably_outdated_installed}
}

function yarn_global_install_packages() {
  local install=("$@")
  local installed=($(yarn_global_installed_packages))
  declare -a to_install
  local len=${#install[@]}
  local marker='INSTALLED'

  for target in ${installed}; do
    for (( i=0; i<=${len}; i++ )); do
      if [[ ${install[$i]} = ${target} ]]; then
        install[i]=${marker}
        break
      fi
    done
  done

  for (( i=0; i<=${len}; i++ )); do
    if [[ ${install[$i]} != ${marker} ]]; then
      to_install=(${to_install[@]} ${install[$i]})
    fi
  done

  IFS=$'\n' to_install=($(sort <<<"${to_install[*]}"))
  unset IFS
  # install uninstalled packages
  if [ ${#to_install[@]} -gt 0 ]; then
    echo ""
    echo "Installing global node packages..."
    echo ${to_install}
    yarn global add ${to_install}
  fi
}

function yarn_upgrade_global_outdated() {
  local outdated_installed=($(yarn_outdated_global_installed_packages))

  echo ""
  echo "Checking for outdated global packages..."

  # update outdated packages
  if [ ${#outdated_installed[@]} -gt 0 ]; then
    echo ""
    echo "Upgrading global node packages..."
    yarn global upgrade ${outdated_installed} --latest
  fi
}
