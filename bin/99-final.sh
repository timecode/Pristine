#!/usr/bin/env sh

echo
echo "Done! Now exit this shell and create a new one to use the new setup..."
echo
echo "or run:"
# shellcheck disable=SC2016
echo 'exec "${SHELL}"'
echo
echo
echo "Will attempt to automatically load a new shell now anyway, so this session can continue..."
exec "${SHELL}"
