#!/usr/bin/env zsh

SCRIPTS_PATH="$(cd "$(dirname "${0}")" >/dev/null 2>&1 || exit ; pwd -P)/.."
# shellcheck source=/dev/null
. "${SCRIPTS_PATH}/conf/rust/helpers.sh"
. "${SCRIPTS_PATH}/conf/brew/helpers.sh"

######################################
# rust
echo
echo "Checking rust status..."

ensure_cargo
ensure_latest_rust

######################################
# rust crates

echo "Checking for uninstalled Rust companions..."

declare rust_companions=(

  sccache
  bacon

)
brew_install_bottles "${rust_companions[@]}"
