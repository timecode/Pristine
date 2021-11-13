#!/usr/bin/env zsh

SCRIPTS_PATH="$(cd "$(dirname "${0}")" >/dev/null 2>&1 || exit ; pwd -P)/.."

################################################################################
# Install Prezto

echo
echo "Installing Prezto ..."
if [ -f "${ZDOTDIR:-$HOME}/.zprezto/init.zsh" ]; then
  . "${ZDOTDIR:-$HOME}/.zprezto/init.zsh" || true
  # shellcheck source=/dev/null
  echo "... Prezto already installed (updating ...)"
  ## PERFORMING UPDATES
  # Run this command ...
  zprezto-update
  # or, pull the latest changes and update submodules manually with:
  # $ cd $ZPREZTODIR
  # $ git pull && git submodule update --init --recursive
else
  [ -d "${ZDOTDIR:-$HOME}/.zprezto" ] && rm -rf "${ZDOTDIR:-$HOME}/.zprezto"
  [ -f "${ZDOTDIR:-$HOME}/.zpreztorc" ] && rm -f "${ZDOTDIR:-$HOME}/.zpreztorc"
  git clone --recursive "https://github.com/sorin-ionescu/prezto.git" "${ZDOTDIR:-$HOME}/.zprezto"
  # Configure prezto
  setopt EXTENDED_GLOB
  for rcfile in ${ZDOTDIR:-$HOME}/.zprezto/runcoms/^README.md(.N); do
    rm -f "${ZDOTDIR:-$HOME}/.${rcfile:t}"
    ln -s "${rcfile}" "${ZDOTDIR:-$HOME}/.${rcfile:t}"
  done
fi

#####################################
echo "... adding custom prompt ..."

cp \
  "${SCRIPTS_PATH}/conf/prezto/prompt_pristine_setup.sh" \
  "${ZDOTDIR:-$HOME}/.zprezto/modules/prompt/functions/prompt_pristine_setup"
if [ $? -ne 0 ]; then
  echo "... continuing ..."
fi

#####################################
echo "... modifying .zpretzorc ..."

RC=$(readlink -n ${ZDOTDIR:-$HOME}/.zpreztorc)

sed -i '' "s/zstyle ':prezto:module:prompt' theme 'sorin'/zstyle ':prezto:module:prompt' theme 'pristine'/g" ${RC}
sed -i '' "s/zstyle ':prezto:module:editor' key-bindings 'emacs'/zstyle ':prezto:module:editor' key-bindings 'vi'/g" ${RC}
# sed -i '' "s/\s*zstyle \':prezto:load\' pmodule \\\.*/zstyle ':prezto:load' pmodule 'git' 'python' 'ruby' 'node' \\\/g" ${RC} 
# removing node module due to prezto-grunt-cache.502.zsh:37: command not found: compdef
sed -i '' "s/\s*zstyle \':prezto:load\' pmodule \\\.*/zstyle ':prezto:load' pmodule 'git' 'python' 'ruby' \\\/g" ${RC}

