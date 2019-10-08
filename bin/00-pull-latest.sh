#!/bin/zsh

################################################################################
# Update this repo

echo ""
cd $(dirname $0)/../

if output=$(git status --porcelain) && [ -z "$output" ]; then
  echo "Attempting to update this repo first..."
  git pull
else
  echo "This repo has uncommited changes, so ignoring update..."
fi
