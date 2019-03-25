function pip2_install() {
  local arr=("$@")
  echo "Installing global pip packages"
  PIP_REQUIRE_VIRTUALENV=false pip2 install -U "${arr[@]}"
}

function pip3_install() {
  local arr=("$@")
  echo "Installing global pip packages"
  PIP_REQUIRE_VIRTUALENV=false pip3 install -U "${arr[@]}"
}
