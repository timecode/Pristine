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
      # special case !
      if [[ "${element}" == "yarn" ]]; then
        brew install ${element} --without-node
      else
        brew install ${element}
      fi
    done
  fi
}

function brew_install_casks() {
  local arr=("$@")
  local installed=($(brew_installed_casks))
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
