bindkey -e                     # Emacs bindings in the shell

stty -ixon                     # Disable Ctrl+S/Ctrl+Q

setopt autocd                  # `cd` into directory without typing `cd`
setopt automenu                # Use menu completion
setopt badpattern              # Error when filename generation pattern is badly formed
setopt extendedglob            # Treat `#`, `~`, and `^` as part of patterns for filename generation
setopt globdots                # Glob wildcards match dotfiles
setopt globstarshort           # Recursive `**` and `***` matching
setopt histignoredups          # Ignore duplicates in history file
setopt histnostore             # Don't store the `history` command in the history
setopt histsavebycopy          # Save separate history files when re-trimming
setopt histverify              # Don't execute history expanded result immediately
setopt nobeep                  # Don't beep on error in ZLE
setopt nocaseglob              # Case insensitive globbing
setopt nomatch                 # Error if filename generation has no matches
setopt nomenucomplete          # Don't insert matches on completion request (avoid conflict with automenu)
setopt nopromptbang            #
setopt nopromptsubst           #
setopt nowarncreateglobal      # Don't warn when making global variables in scoped functions
setopt nowarnnestedvar         # Don't warn when using existing variable in nested function scopes
setopt promptcr                #
setopt promptpercent           #
setopt promptsp                #

# ----------------------------------------------------------------------------

HISTSIZE=3000
SAVEHIST=10000

# ----------------------------------------------------------------------------

autoload -Uz compinit add-zsh-hook

compinit -d "${XDG_CACHE_HOME}/zsh/zcompdump-${ZSH_VERSION}"

zstyle :compinstall filename "${XDG_CONFIG_HOME}/zsh/.zshrc"
zstyle ":completion:*" menu select
zstyle ":completion::complete:*" gain-privileges 1

# ----------------------------------------------------------------------------

source "${XDG_CONFIG_HOME}/shell/aliases.sh"

source "${XDG_CONFIG_HOME}/zsh/zsh_prompt.zsh"
source "${XDG_DATA_HOME}/zsh/zsh_syntax_highlighting/zsh-syntax-highlighting.zsh"
