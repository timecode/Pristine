function pip2_install() {
  local arr=("$@")
  pip2 install -U "${arr[@]}"
}

function pip3_install() {
  local arr=("$@")
  pip3 install -U "${arr[@]}"
}
