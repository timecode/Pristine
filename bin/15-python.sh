#!/usr/bin/env zsh

SCRIPTS_PATH="$(cd "$(dirname "${0}")" >/dev/null 2>&1 || exit ; pwd -P)/.."
# shellcheck source=/dev/null
. "${SCRIPTS_PATH}/conf/python/helpers.sh"

######################################
# python installs

echo
LOCAL_BIN=/usr/local/bin
# echo "Forcing python3.8 to be default..."
# ln -fs ${LOCAL_BIN}/python3.8 ${LOCAL_BIN}/python
# ln -fs ${LOCAL_BIN}/pip3 ${LOCAL_BIN}/pip

echo "Forcing python3.9 to be default..."
BREW_PYTHON_BIN=/usr/local/opt/python@3.9/bin

install_check=$(${BREW_PYTHON_BIN}/python3 --version >/dev/null 2>&1)
if [ $? -eq 0 ]; then
  ln -fs ${BREW_PYTHON_BIN}/python3 ${LOCAL_BIN}/python
fi

# includes fix for brew issues when python version changes!
install_check=$(${BREW_PYTHON_BIN}/pip3 --version >/dev/null 2>&1)
if [ $? -eq 0 ]; then
  ln -fs ${BREW_PYTHON_BIN}/pip3 ${LOCAL_BIN}/pip
else
  install_check=$(${LOCAL_BIN}/pip3 --version >/dev/null 2>&1)
  if [ $? -eq 0 ]; then
    ln -fs ${LOCAL_BIN}/pip3 ${LOCAL_BIN}/pip
  fi
fi

echo
echo "Setting up python environment..."
pip_install pip setuptools

echo
echo "Installing system python modules..."
declare my_essential_python_modules=(
  pipenv
  autopep8
)
pip_install "${my_essential_python_modules[@]}"

declare my_system_python_modules=(
  speedtest-cli
)
pip_install "${my_system_python_modules[@]}"
