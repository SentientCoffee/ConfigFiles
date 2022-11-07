#!/bin/bash

stty -ixon               # Disable Ctrl+S/Ctrl+Q

shopt -s autocd          # cd into directory without typing cd
shopt -s checkwinsize    # check window size after each command
shopt -s dotglob         # Glob wildcards match dotfiles
shopt -s globstar        # ** recursive matching
shopt -s histappend      # Append to history file
shopt -s histverify      # Don't execute expanded result immediately
shopt -s nocaseglob      # Case-insensitive globbing

# ----------------------------------------------------------------------------

HISTCONTROL=ignoreboth   # Don't insert duplicate lines or lines starting with space in history
HISTSIZE= HISTFILESIZE=  # Infinite shell history

# ----------------------------------------------------------------------------

source "${XDG_CONFIG_HOME}/shell/aliases.sh"

source "${XDG_CONFIG_HOME}/bash/bash_prompt.bash"
source "${XDG_CONFIG_HOME}/bash/bash_completions.bash"
