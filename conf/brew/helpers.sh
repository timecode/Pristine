export HOMEBREW_NO_AUTO_UPDATE=1

function brew_installed_bottles() {
  echo $(brew ls -1)
}

function brew_installed_casks() {
  echo $(brew cask ls -1)
}

function brew_installed_bottles_list() {
  local installed=($(brew_installed_bottles))
  if [ ${#installed[@]} -gt 0 ]; then
    echo ""
    echo "Currently installed bottles..."
    brew ls --versions ${installed}
  fi
}

function brew_installed_casks_list() {
  local installed=($(brew_installed_casks))
  if [ ${#installed[@]} -gt 0 ]; then
    echo ""
    echo "Currently installed casks..."
    brew cask ls --versions ${installed}
  fi
}

function brew_install_bottles() {
  local arr=("$@")
  local installed=($(brew_installed_bottles))
  if [ ${#installed[@]} -eq 0 ]; then
    installed=("EMPTY!")
  fi
  local install=()
  # find uninstalled tools
  for element in "${arr[@]}"; do
    $(for e in "${installed[@]}"; do [[ "${e}" == "${element}" ]] && exit 0; done)
    if [ $? -ne 0 ]; then
      install+=(${element})
    fi
  done
  IFS=$'\n' sorted=($(sort <<<"${install[*]}"))
  unset IFS
  # install uninstalled bottles
  if [ ${#sorted[@]} -gt 0 ]; then
    for element in "${sorted[@]}"; do
      echo "... installing ${element}"
      if [[ "${element}" == "yarn" ]]; then
        # special case !
        brew install ${element} --ignore-dependencies
        # ln -sf $(which node) /usr/local/Cellar/
      else
        brew install ${element}
      fi
    done
  fi
}

function brew_install_casks() {
  local arr=("$@")
  local installed=($(brew_installed_casks))
  if [ ${#installed[@]} -eq 0 ]; then
    installed=("EMPTY!")
  fi
  local install=()
  # find uninstalled tools
  for element in "${arr[@]}"; do
    $(for e in "${installed[@]}"; do [[ "${e}" == "${element}" ]] && exit 0; done)
    if [ $? -ne 0 ]; then
      install+=(${element})
    fi
  done
  IFS=$'\n' sorted=($(sort <<<"${install[*]}"))
  unset IFS
  # install uninstalled casks
  if [ ${#sorted[@]} -gt 0 ]; then
    for element in "${sorted[@]}"; do
      brew cask install ${element}
    done
  fi
}
