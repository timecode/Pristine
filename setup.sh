#!/usr/bin/env zsh

set -e

SCRIPTS_PATH="$(cd "$(dirname "${0}")" >/dev/null 2>&1 || exit ; pwd -P)"

declare files=()
while IFS=$'\n' read -r l; do files+=( "${l}" ); done < <(find "${SCRIPTS_PATH}/bin" -maxdepth 1 -name '*.sh' | sort -n)
unset IFS

for file in "${files[@]}" ; do
  "${file}"
done
