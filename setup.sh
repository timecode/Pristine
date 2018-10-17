#!/bin/zsh
set -e

scriptDirectory=$(exec 2>/dev/null; cd -- $(dirname "$0"); /usr/bin/pwd || /bin/pwd || pwd)

FILES=($(ls ${scriptDirectory}/bin | sort -n))
for file in ${FILES[@]} ; do
  ${scriptDirectory}/bin/${file}
done

################################################################################
echo ""
echo "Done! Now exit this shell and create a new one to use the new setup..."
echo ""
echo "Or run:"
echo 'exec "$SHELL"'
echo ""
