#!/bin/zsh
set -e

FILES=($(ls bin | sort -n))
for file in ${FILES[@]} ; do
  ./bin/${file}
done

################################################################################
echo ""
echo "Done! Now exit this shell and create a new one to use the new setup."
echo ""
