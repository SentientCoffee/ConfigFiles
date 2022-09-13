#!/bin/sh

stty -ixon               # Disable Ctrl+S/Ctrl+Q

shopt -s autocd          # cd into directory without typing cd
shopt -s dotglob         # Glob wildcards match dotfiles
shopt -s globstar        # ** recursive matching
shopt -s histverify      # Don't execute expanded result immediately
shopt -s nocaseglob      # Case-insensitive globbing

# ----------------------------------------------------------------------------

HISTSIZE= HISTFILESIZE=  # Infinite shell history

# ----------------------------------------------------------------------------

source "${XDG_CONFIG_HOME}/shell/env.sh"
source "${XDG_CONFIG_HOME}/shell/aliases.sh"
source "${XDG_CONFIG_HOME}/shell/ssh_autostart.sh"

source "${XDG_CONFIG_HOME}/bash/bash_prompt.bash"
source "${XDG_CONFIG_HOME}/bash/bash_completions.bash"
