#!/usr/bin/env zsh

SCRIPTS_PATH="$(cd "$(dirname "${0}")" >/dev/null 2>&1 || exit ; pwd -P)/.."
# shellcheck source=/dev/null
. "${SCRIPTS_PATH}/conf/brew/helpers.sh"
. "${SCRIPTS_PATH}/conf/python/helpers.sh"

ensure_brew_bin

######################################
# python installs

LOCAL_BIN_INTEL=/usr/local/bin
LOCAL_BIN_ARM=/opt/homebrew/bin

BREW_PYTHON_BIN_INTEL=/usr/local/opt/python3/bin
BREW_PYTHON_BIN_ARM=/opt/homebrew/opt/python3/bin

[ -d $BREW_PYTHON_BIN_ARM ] && \
  BREW_PYTHON_BIN=$BREW_PYTHON_BIN_ARM && \
  LOCAL_BIN=$LOCAL_BIN_ARM
[ -z $BREW_PYTHON_BIN ] && [ -d $BREW_PYTHON_BIN_INTEL ] && \
  BREW_PYTHON_BIN=$BREW_PYTHON_BIN_INTEL && \
  LOCAL_BIN=$LOCAL_BIN_INTEL

# echo
# echo "Forcing python3 to be default..."
# ln -fs ${LOCAL_BIN}/python3 ${LOCAL_BIN}/python
# ln -fs ${LOCAL_BIN}/pip3 ${LOCAL_BIN}/pip

# ######################### FIXED VERSION START #########################
# OPTIONAL: To set a fixed version of python
# if installed with, for example, brew install python@3.11

PYTHON_VERSION=3.11

BREW_PYTHON_BIN_INTEL=/usr/local/opt/python@$PYTHON_VERSION/bin
BREW_PYTHON_BIN_ARM=/opt/homebrew/opt/python@$PYTHON_VERSION/bin

[ -d $BREW_PYTHON_BIN_ARM ] && \
  BREW_PYTHON_BIN=$BREW_PYTHON_BIN_ARM && \
  LOCAL_BIN=$LOCAL_BIN_ARM
[ -z $BREW_PYTHON_BIN ] && [ -d $BREW_PYTHON_BIN_INTEL ] && \
  BREW_PYTHON_BIN=$BREW_PYTHON_BIN_INTEL && \
  LOCAL_BIN=$LOCAL_BIN_INTEL

[ -z $BREW_PYTHON_BIN ] && echo "Unable to find ${PYTHON_VERSION} ..." && exit

echo
echo "Forcing ${PYTHON_VERSION} to be default..."

install_check=$(${BREW_PYTHON_BIN}/python${PYTHON_VERSION} --version >/dev/null 2>&1)
if [ $? -eq 0 ]; then
  ln -fs ${BREW_PYTHON_BIN}/python${PYTHON_VERSION} ${LOCAL_BIN}/python
fi

# includes fix for brew issues when python version changes!
install_check=$(${BREW_PYTHON_BIN}/pip${PYTHON_VERSION} --version >/dev/null 2>&1)
if [ $? -eq 0 ]; then
  ln -fs ${BREW_PYTHON_BIN}/pip${PYTHON_VERSION} ${LOCAL_BIN}/pip
else
  install_check=$(${LOCAL_BIN}/pip${PYTHON_VERSION} --version >/dev/null 2>&1)
  if [ $? -eq 0 ]; then
    ln -fs ${LOCAL_BIN}/pip${PYTHON_VERSION} ${LOCAL_BIN}/pip
  fi
fi
# ########################## FIXED VERSION END ##########################

echo
echo "Setting up python environment..."
pip_install pip setuptools

# ensure python -m site --user-base is setup
python_base_path="$(python -m site --user-base)"
mkdir -p $python_base_path
ln -fs "$python_base_path" "$(dirname $python_base_path)/Current"

python_library_bin="$(dirname $python_base_path)/Current/bin"
PATH="${HOME}/.local/bin:$python_library_bin:$PATH"
pipx_bin_path="$python_library_bin"

# install pipx
pip install --user -U pipx --no-warn-script-location
# pipx ensurepath --force

echo
echo "Checking for upgrades..."
pipx upgrade-all

echo
echo "Checking for uninstalled dependencies..."
declare my_essential_python_modules=(
  pipenv
  autopep8
)
pipx_install "${my_essential_python_modules[@]}"

declare my_other_python_modules=(
  speedtest-cli
  awscli-plugin-endpoint
)
pipx_install "${my_other_python_modules[@]}"
