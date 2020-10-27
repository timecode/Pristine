#!/usr/bin/env bash

export HOMEBREW_NO_AUTO_UPDATE=1

brew_installed_bottles() {
  brew list --formula -1
}

brew_installed_casks() {
  brew list --cask -1
}

brew_installed_bottles_list() {
  local -a installed=()
  while IFS=$'\n' read -r l; do installed+=( "${l}" ); done < <(echo "$(brew_installed_bottles) ")
  unset IFS
  if [ "${#installed[*]}" -gt 0 ]; then
    echo
    echo "Currently installed bottles..."
    brew list --formula --versions "${installed[@]}"
  fi
}

brew_installed_casks_list() {
  local -a installed
  while IFS=$'\n' read -r l; do installed+=( "${l}" ); done < <(brew_installed_casks)
  unset IFS
  if [ "${#installed[@]}" -gt 0 ]; then
    echo
    echo "Currently installed casks..."
    brew list --cask --versions "${installed[@]}"
  fi
}

brew_install_bottles() {
  local install=("${@}")
  local -a to_install
  local -a installed
  while read -r -d $'\n' l; do installed+=( "${l}" ); done < <(echo "$(brew_installed_bottles) ")

  len="${#install[@]}"
  if [ "${len}" -gt 0 ]; then
    local marker='INSTALLED'
    for target in "${installed[@]}"; do
      for (( i=0; i<len; i++ )); do
        if [[ "${install[${i}]}" = "${target}" ]]; then
          install[i]="${marker}"
          break
        fi
      done
    done
    for (( i=0; i<len; i++ )); do
      if [[ "${install[${i}]}" != "${marker}" ]]; then
        to_install+=("${install[${i}]}")
      fi
    done
  fi

  if [ "${#to_install[@]}" -gt 0 ]; then
    local -a sorted_install=()
    IFS=$'\n' sorted_install=("$(sort <<<"${to_install[*]}")")
    unset IFS
    to_install=()
    while read -r l; do to_install+=( "${l}" ); done < <(echo "${sorted_install[*]}")

    # install uninstalled
    for e in "${to_install[@]}"; do
      echo "... installing '${e}'"
      if [[ "${e}" == "yarn" ]]; then
        # special case !
        brew install "${e}"
        # ln -sf $(which node) /usr/local/Cellar
      else
        brew install "${e}"
      fi
    done
  fi
}

brew_install_casks() {
  local install=("${@}")
  local -a to_install
  local -a installed
  while read -r -d $'\n' l; do installed+=( "${l}" ); done < <(echo "$(brew_installed_casks) ")

  len="${#install[@]}"
  if [ "${len}" -gt 0 ]; then
    local marker='INSTALLED'
    for target in "${installed[@]}"; do
      for (( i=0; i<len; i++ )); do
        if [[ "${install[${i}]}" = "${target}" ]]; then
          install[i]="${marker}"
          break
        fi
      done
    done
    for (( i=0; i<len; i++ )); do
      if [[ "${install[${i}]}" != "${marker}" ]]; then
        to_install+=("${install[${i}]}")
      fi
    done
  fi

  if [ "${#to_install[@]}" -gt 0 ]; then
    local -a sorted_install=()
    IFS=$'\n' sorted_install=("$(sort <<<"${to_install[*]}")")
    unset IFS
    to_install=()
    while read -r l; do to_install+=( "${l}" ); done < <(echo "${sorted_install[*]}")

    # install uninstalled
    for e in "${to_install[@]}"; do
      echo "... installing '${e}'"
      brew cask install "${e}"
    done
  fi
}

brew_upgrade_bottles() {
  brew upgrade
}

brew_upgrade_casks() {
  local -a installed
  while read -r -d $'\n' l; do installed+=( "${l}" ); done < <(echo "$(brew_installed_casks) ")
  brew upgrade --quiet --casks "${installed[@]}"
}

