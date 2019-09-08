function pip_install() {
  local arr=("$@")
  echo "Installing global pip packages"
  PIP_REQUIRE_VIRTUALENV=false pip3 install -U "${arr[@]}"
}
