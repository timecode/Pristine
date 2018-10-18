#!/bin/zsh
set -e

scriptDirectory=$(exec 2>/dev/null; cd -- $(dirname "$0"); /usr/bin/pwd || /bin/pwd || pwd)

FILES=($(ls ${scriptDirectory}/bin | sort -n))
for file in ${FILES[@]} ; do
  ${scriptDirectory}/bin/${file}
done
