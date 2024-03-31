#!/usr/bin/env zsh

pip_install() {
  local arr=("$@")
  echo "Installing global pip packages"
  PIP_REQUIRE_VIRTUALENV=false pip install -U "${arr[@]}"
}

pipx_install() {
  local arr=("$@")
  pipx_home="${HOME}/.local/pipx/"
  for e in "${arr[@]}"; do
    # if [ ! -e "${HOME}/Library/Application Support/pipx/venvs/${e}" ]; then
    if [ ! -e "${pipx_home}/${e}" ]; then
      echo "... installing '${e}'"
      PIPX_HOME="${pipx_home}" pipx install --include-deps "${e}"
    fi
  done
}
