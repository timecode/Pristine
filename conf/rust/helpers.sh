#!/usr/bin/env zsh

export CARGO_DIR="${HOME}/.cargo"

##############################################################################
### cargo ####################################################################
##############################################################################

ensure_cargo() {
  if [ -f "${CARGO_DIR}/env" ]; then
    echo "... a version of cargo is already installed"
  else
    echo "... installing cargo"
    curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
  fi
}

##############################################################################
### rust #####################################################################
##############################################################################

ensure_latest_rust() {
  # shellcheck source=/dev/null
  [ -s "${CARGO_DIR}/env" ] && . "${CARGO_DIR}/env"  # This loads cargo

  echo
  echo "Ensuring latest rust ..."

  rustup update
}
