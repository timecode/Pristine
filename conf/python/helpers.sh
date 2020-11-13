#!/usr/bin/env zsh

pip_install() {
  local arr=("$@")
  echo "Installing global pip packages"
  PIP_REQUIRE_VIRTUALENV=false pip install -U "${arr[@]}"
}
