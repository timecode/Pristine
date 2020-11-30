#!/usr/bin/env zsh

SCRIPTS_PATH="$(cd "$(dirname "${0}")" >/dev/null 2>&1 || exit ; pwd -P)/.."
# shellcheck source=/dev/null
. "${SCRIPTS_PATH}/conf/python/helpers.sh"

######################################
# python installs

echo
# echo "Forcing python3.8 to be default..."
# ln -fs /usr/local/bin/python3.8 /usr/local/bin/python
# ln -fs /usr/local/bin/pip3 /usr/local/bin/pip
echo "Forcing python3.9 to be default..."
ln -fs /usr/local/opt/python@3.9/bin/python3 /usr/local/bin/python
ln -fs /usr/local/opt/python@3.9/bin/pip3 /usr/local/bin/pip

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
