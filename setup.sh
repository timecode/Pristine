#!/usr/bin/env zsh

set -e

SCRIPTS_PATH="$(cd "$(dirname "${0}")" >/dev/null 2>&1 || exit ; pwd -P)"

export MAC_OS_VER=$(sw_vers -productVersion | sed -E 's/^([0-9]+)\.*.*$/\1/')
export BREW_DIR_INTEL=/usr/local/Homebrew
export BREW_DIR_ARM=/opt/homebrew

[ -d $BREW_DIR_ARM ] && export BREW_DIR=$BREW_DIR_ARM
[ -z $BREW_DIR ] && [ -d $BREW_DIR_INTEL ] && export BREW_DIR=$BREW_DIR_INTEL

declare files=()
while IFS=$'\n' read -r l; do files+=( "${l}" ); done < <(find "${SCRIPTS_PATH}/bin" -maxdepth 1 -name '*.sh' | sort -n)
unset IFS

for file in "${files[@]}" ; do
  "${file}"
done
