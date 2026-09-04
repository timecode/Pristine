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

# sed -i '' "s/zstyle ':prezto:module:prompt' theme 'sorin'/zstyle ':prezto:module:prompt' theme 'pristine'/g" ${RC}
# sed -i '' "s/zstyle ':prezto:module:editor' key-bindings 'emacs'/zstyle ':prezto:module:editor' key-bindings 'vi'/g" ${RC}
# # sed -i '' "s/\s*zstyle \':prezto:load\' pmodule \\\.*/zstyle ':prezto:load' pmodule 'git' 'python' 'ruby' 'node' \\\/g" ${RC}
# # removing node module due to prezto-grunt-cache.502.zsh:37: command not found: compdef
# sed -i '' "s/\s*zstyle \':prezto:load\' pmodule \\\.*/zstyle ':prezto:load' pmodule 'git' 'python' 'ruby' \\\/g" ${RC}

# ^ In BSD sed, the -i option requires an extension argument for backups. Passing '' explicitly tells BSD sed not to create a backup file
# GNU sed treats the -i option differently (the backup extension is optional and must follow -i immediately - no space = e.g. -i.bak)
# Solution a simple universal standard POSIX redirection with a temp file; avoids -i incompatibility
# sed "s/zstyle ':prezto:module:prompt' theme 'sorin'/zstyle ':prezto:module:prompt' theme 'pristine'/g" "${RC}" > "${RC}.tmp" && mv -f "${RC}.tmp" "${RC}"
# or, setup the command in advance (based on the version of sed in use), then use that...
sedi() { sed --version >/dev/null 2>&1 && sed -i "$@" || sed -i '' "$@"; }
sedi "s/zstyle ':prezto:module:prompt' theme 'sorin'/zstyle ':prezto:module:prompt' theme 'pristine'/g" "${RC}"
sedi "s/zstyle ':prezto:module:editor' key-bindings 'emacs'/zstyle ':prezto:module:editor' key-bindings 'vi'/g" ${RC}
sedi "s/\s*zstyle \':prezto:load\' pmodule \\\.*/zstyle ':prezto:load' pmodule 'git' 'python' 'ruby' \\\/g" ${RC}
