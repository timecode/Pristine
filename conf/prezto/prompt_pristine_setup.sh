#!/usr/bin/env zsh

# A fork of Paradox
# A two-line, Powerline-inspired theme that displays contextual information.
#
# This theme requires a patched Powerline font, get them from
# https://github.com/Lokaltog/powerline-fonts.
#

# Load dependencies.
pmodload 'helper'

# Define variables.
_prompt_paradox_current_bg='NONE'
_prompt_paradox_segment_separator=''
_prompt_paradox_start_time="${SECONDS}"

prompt_paradox_start_segment() {
  local bg fg
  [[ -n "${1}" ]] && bg="%K{${1}}" || bg="%k"
  [[ -n "${2}" ]] && fg="%F{${2}}" || fg="%f"
  if [[ "${_prompt_paradox_current_bg}" != 'NONE' && "${1}" != "${_prompt_paradox_current_bg}" ]]; then
    print -n " ${bg}%F{$_prompt_paradox_current_bg}${_prompt_paradox_segment_separator}${fg}"
  else
    print -n "${bg}${fg}"
  fi
  _prompt_paradox_current_bg="${1}"
  [[ -n "${3}" ]] && print -n "${3}"
}

prompt_paradox_end_segment() {
  if [[ -n "${_prompt_paradox_current_bg}" ]]; then
    print -n " %k%F{${_prompt_paradox_current_bg}}${_prompt_paradox_segment_separator}"
  else
    print -n "%k"
  fi
  print -n "%f"
  _prompt_paradox_current_bg=''
}

prompt_paradox_build_prompt() {
  # prompt_paradox_start_segment black default '%(?::%F{red}✘ )%(!:%F{yellow}⚡ :)%(1j:%F{cyan}⚙ :)%F{blue}%n%F{red}@%F{green}%m%f'
  # prompt_paradox_start_segment black default '%F{blue}# %(?::%F{red}✘)%(!:%F{yellow}⚡ :)%(1j:%F{cyan}⚙ :)'
  prompt_paradox_start_segment black default '%F{blue}#%(?::%F{red} ✘)'

  if [[ -n "${python_info}" ]]; then
    prompt_paradox_start_segment blue black ' ${(e)python_info[virtualenv]}'
  fi

  if [[ "${USER}" != "${DEFAULT_USER}" ]] ||
      [[ -n "${SSH_CLIENT}" ]] ||
      [[ -n "${SSH_TTY}" ]]; then
    local shell_identifier="${USER}"
    if [[ -n "${PROMPT_MACHINE_SHORTNAME}" ]]; then
      shell_identifier="${PROMPT_MACHINE_SHORTNAME}"
    fi
    prompt_paradox_start_segment red black " ${shell_identifier}"
  fi

  prompt_paradox_start_segment cyan black ' $_prompt_paradox_pwd'

  if [[ -n "${git_info}" ]]; then
    prompt_paradox_start_segment yellow black '${(e)git_info[ref]}${(e)git_info[status]}'
  fi

  prompt_paradox_end_segment
}

prompt_paradox_print_elapsed_time() {
  local end_time=$(( SECONDS - _prompt_paradox_start_time ))
  local hours minutes seconds remainder

  if (( end_time >= 3600 )); then
    hours=$(( end_time / 3600 ))
    remainder=$(( end_time % 3600 ))
    minutes=$(( remainder / 60 ))
    seconds=$(( remainder % 60 ))
    print -P "%B%F{red}>>> elapsed time ${hours}h${minutes}m${seconds}s%b"
  elif (( end_time >= 60 )); then
    minutes=$(( end_time / 60 ))
    seconds=$(( end_time % 60 ))
    print -P "%B%F{yellow}>>> elapsed time ${minutes}m${seconds}s%b"
  elif (( end_time > 10 )); then
    print -P "%B%F{green}>>> elapsed time ${end_time}s%b"
  fi
}

prompt_paradox_precmd() {
  setopt LOCAL_OPTIONS
  unsetopt XTRACE KSH_ARRAYS

  # Format PWD.
  _prompt_paradox_pwd="$(prompt-pwd)"

  # Get Git repository information.
  if (( $+functions[git-info] )); then
    git-info
  fi

  # Get Python environment information.
  if (( $+functions[python-info] )); then
    python-info
  fi

  # Calculate and print the elapsed time.
  prompt_paradox_print_elapsed_time
}

prompt_paradox_preexec() {
  _prompt_paradox_start_time="${SECONDS}"
}

prompt_paradox_setup() {
  setopt LOCAL_OPTIONS
  unsetopt XTRACE KSH_ARRAYS
  prompt_opts=(cr percent sp subst)

  # Load required functions.
  autoload -Uz add-zsh-hook

  # Add hook for calling git-info before each command.
  add-zsh-hook preexec prompt_paradox_preexec
  add-zsh-hook precmd prompt_paradox_precmd

  # Tell prezto we can manage this prompt
  zstyle ':prezto:module:prompt'                                managed 'yes'

  # Set editor-info parameters.
  zstyle ':prezto:module:editor:info:completing'                format '%B%F{red}...%f%b'
  zstyle ':prezto:module:editor:info:keymap:primary'            format '%B%F{blue}$%f%b'
  zstyle ':prezto:module:editor:info:keymap:primary:overwrite'  format '%F{red}♺%f'
  zstyle ':prezto:module:editor:info:keymap:alternate'          format '%B%F{red}❮%f%b'

  # Set git-info parameters.
  zstyle ':prezto:module:git:info'                              verbose 'yes'
  zstyle ':prezto:module:git:info:action'                       format ' ⁝ %s'
  zstyle ':prezto:module:git:info:added'                        format ' ✚'
  zstyle ':prezto:module:git:info:ahead'                        format ' ⬆'
  zstyle ':prezto:module:git:info:behind'                       format ' ⬇'
  zstyle ':prezto:module:git:info:branch'                       format ' %b'
  zstyle ':prezto:module:git:info:commit'                       format '➦ %.7c'
  zstyle ':prezto:module:git:info:deleted'                      format ' ✖'
  zstyle ':prezto:module:git:info:dirty'                        format ' ⁝'
  zstyle ':prezto:module:git:info:modified'                     format ' ✱'
  zstyle ':prezto:module:git:info:position'                     format '%p'
  zstyle ':prezto:module:git:info:renamed'                      format ' ➙'
  zstyle ':prezto:module:git:info:stashed'                      format ' S'
  zstyle ':prezto:module:git:info:unmerged'                     format ' ═'
  zstyle ':prezto:module:git:info:untracked'                    format ' ?'
  zstyle ':prezto:module:git:info:keys'                         format      \
    'ref' '$(coalesce "%b" "%p" "%c")'                                      \
    'status' '%s%D%A%B%S%a%d%m%r%U%u'

  # %v - virtualenv name.
  zstyle ':prezto:module:python:info:virtualenv'                format '%v'

  # Define prompts.
  PROMPT='%F{blue}[%F{green}%D{%H:%M:%S}%F{blue}]%f ${(e)$(prompt_paradox_build_prompt)}
${editor_info[keymap]} '
  RPROMPT=''
  SPROMPT='zsh: correct %F{red}%R%f to %F{green}%r%f [nyae]? '
}

prompt_paradox_setup "$@"
