#!/bin/zsh
set -e

./bin/tools.sh
./bin/fonts.sh
./bin/prezto.sh
./bin/dotfiles.sh
./bin/defaultshell.sh
./bin/tmux.sh

################################################################################
echo ""
echo "Done! Now exit this shell and create a new one to use the new setup."
echo ""
