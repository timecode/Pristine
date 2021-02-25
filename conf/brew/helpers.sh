#!/usr/bin/env zsh

# export HOMEBREW_NO_AUTO_UPDATE=1

brew_installed_bottles() {
  brew list --formula -1
}

brew_installed_casks() {
  brew list --cask -1
}

brew_installed_bottles_list() {
  local installed=()
  while IFS=$'\n' read -r l; do installed+=( "${l}" ); done < <(echo "$(brew_installed_bottles) ")
  unset IFS
  if [ "${#installed[*]}" -gt 0 ]; then
    echo
    echo "Currently installed bottles..."
    brew list --formula --versions "${installed[@]}"
  fi
}

brew_installed_casks_list() {
  local installed=()
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
  local to_install=()
  local installed=()
  local i=0
  while read -r -d $'\n' l; do installed+=( "${l}" ); done < <(echo "$(brew_installed_bottles) ")

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
  local to_install=()
  local installed=()
  local i=0
  while read -r -d $'\n' l; do installed+=( "${l}" ); done < <(echo "$(brew_installed_casks) ")

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
    for e in "${to_install[@]}"; do
      echo "... installing '${e}'"
      brew cask install "${e}"
    done
  fi
}

brew_upgrade_bottles() {
  local installed=()
  local to_update=()
  while read -r -d $'\n' l; do installed+=( "${l}" ); done < <(echo "$(brew_installed_bottles) ")

  # remove skipped updates
  len="${#installed[@]}"
  if [ "${len}" -gt 0 ]; then
    local marker='SKIP'
    for target in "${brew_upgrade_skip_list[@]}"; do
      for (( i=1; i<=len; i++ )); do
        if [[ "${installed[${i}]}" = "${target}" ]]; then
          >&2 echo "\e[33m ... skipping '${target}'\e[39m"
          installed[i]="${marker}"
          break
        fi
      done
    done
    for (( i=1; i<=len; i++ )); do
      if [[ "${installed[${i}]}" != "${marker}" ]]; then
        to_update+=("${installed[${i}]}")
      fi
    done
  fi

  # brew insists on a "Warning" for each formulae to be 'upgraded'
  # stating that it's "already installed"
  # We know it's "already installed", we want to upgrade it!
  # At the very least it could say something like "up to date"
  # In any event, it would ideally be hush-able with --quiet (but no!)
  # see https://github.com/Homebrew/brew/issues/10666
  # so... sending all that noise to /dev/null :-/
  # brew upgrade --quiet --formulae "${to_update[@]}" >/dev/null 2>&1

  # Hmmm, so when there ARE updates, ^ we end up running blind so, until
  # --quiet does what's expected, maybe live with the Warnings noise :-(
  brew upgrade --quiet --formulae "${to_update[@]}"
}

brew_upgrade_casks() {
  local installed=()
  local to_update=()
  while read -r -d $'\n' l; do installed+=( "${l}" ); done < <(echo "$(brew_installed_casks) ")

  # remove skipped updates
  len="${#installed[@]}"
  if [ "${len}" -gt 0 ]; then
    local marker='SKIP'
    for target in "${brew_upgrade_skip_list[@]}"; do
      for (( i=1; i<=len; i++ )); do
        if [[ "${installed[${i}]}" = "${target}" ]]; then
          >&2 echo "\e[33m ... skipping '${target}'\e[39m"
          installed[i]="${marker}"
          break
        fi
      done
    done
    for (( i=1; i<=len; i++ )); do
      if [[ "${installed[${i}]}" != "${marker}" ]]; then
        to_update+=("${installed[${i}]}")
      fi
    done
  fi

  brew upgrade --quiet --casks "${to_update[@]}"
}

