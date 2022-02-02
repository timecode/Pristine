#!/usr/bin/env zsh

pip_install() {
  local arr=("$@")
  echo "Installing global pip packages"
  PIP_REQUIRE_VIRTUALENV=false pip install -U "${arr[@]}"
}

pipx_install() {
  local arr=("$@")
  for e in "${arr[@]}"; do
    if [ -z "${HOME}/.local/pipx/venvs/${e}" ]; then
      echo "... installing '${e}'"
      pipx install --include-deps "${e}"
    else
      echo "... upgrade '${e}' ?"
      pipx upgrade "${e}"
    fi
  done
}
