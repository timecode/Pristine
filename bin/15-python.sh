#!/usr/bin/env zsh

SCRIPTS_PATH="$(cd "$(dirname "${0}")" >/dev/null 2>&1 || exit ; pwd -P)/.."
# shellcheck source=/dev/null
. "${SCRIPTS_PATH}/conf/python/helpers.sh"

######################################
# python installs

PYTHON_VERSION=python@3.10

LOCAL_BIN_INTEL=/usr/local/bin
LOCAL_BIN_ARM=/opt/homebrew/bin
BREW_PYTHON_BIN_INTEL=/usr/local/opt/$PYTHON_VERSION/bin
BREW_PYTHON_BIN_ARM=/opt/homebrew/opt/$PYTHON_VERSION/bin

[ -d $BREW_PYTHON_BIN_ARM ] && \
  BREW_PYTHON_BIN=$BREW_PYTHON_BIN_ARM && \
  LOCAL_BIN=$LOCAL_BIN_ARM
[ -z $BREW_PYTHON_BIN ] && [ -d $BREW_PYTHON_BIN_INTEL ] && \
  BREW_PYTHON_BIN=$BREW_PYTHON_BIN_INTEL && \
  LOCAL_BIN=$LOCAL_BIN_INTEL

[ -z $BREW_PYTHON_BIN ] && echo "Unable to find ${PYTHON_VERSION} ..." && exit

echo
echo "Forcing ${PYTHON_VERSION} to be default..."
# ln -fs ${LOCAL_BIN}/python3.10 ${LOCAL_BIN}/python
# ln -fs ${LOCAL_BIN}/pip3 ${LOCAL_BIN}/pip

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
  awscli-plugin-endpoint
)
pip_install "${my_system_python_modules[@]}"
