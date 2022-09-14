#
# ~/.config/bash/bash_prompt
#

# Foreground colors
FG_INVERSE="7"
FG_DEFAULT="39"

FG_BLACK="30"
FG_RED="31"
FG_GREEN="32"
FG_YELLOW="33"
FG_BLUE="34"
FG_MAGENTA="35"
FG_CYAN="36"
FG_WHITE="37"

FG_BRIGHT_BLACK="90"
FG_BRIGHT_RED="91"
FG_BRIGHT_GREEN="92"
FG_BRIGHT_YELLOW="93"
FG_BRIGHT_BLUE="94"
FG_BRIGHT_MAGENTA="95"
FG_BRIGHT_CYAN="96"
FG_BRIGHT_WHITE="97"

# Background colors
BG_DEFAULT="39"

BG_BLACK="40"
BG_RED="41"
BG_GREEN="42"
BG_YELLOW="43"
BG_BLUE="44"
BG_MAGENTA="45"
BG_CYAN="46"
BG_WHITE="47"

BG_BRIGHT_BLACK="100"
BG_BRIGHT_RED="101"
BG_BRIGHT_GREEN="102"
BG_BRIGHT_YELLOW="103"
BG_BRIGHT_BLUE="104"
BG_BRIGHT_MAGENTA="105"
BG_BRIGHT_CYAN="106"
BG_BRIGHT_WHITE="107"

# Symbols
CURRENT_TTY=$(tty)
if [[ ${CURRENT_TTY} =~ "/dev/pts" && $EUID -ne 0 ]]; then
    STARTER=""
    SEPARATOR=""
    ENDER=""
else
    STARTER=""
    SEPARATOR=""
    ENDER=""
fi

# Special sequences
NEWLINE="\n"
USER_HOST="\u@\h"
DIRECTORY="\w"
SHELL_PROMPT="\s \\$"

# Color combos
# NOTE: Using \[ and \] around colors (and any NON-PRINTING characters)
# is necessary to prevent issues with command line editing/browsing/completion!
RESET="\[\e[0m\]"
BOLD="\[\e[1m\]"
INVERSE="\[\e[7m\]"

printf -v START_COLOR_1        "\[\e[%s;%sm\]" "$FG_INVERSE"      "$FG_RED"
printf -v USER_HOST_COLOR      "\[\e[%s;%sm\]" "$FG_BRIGHT_WHITE" "$BG_RED"
printf -v TRANSITION_COLOR_1_1 "\[\e[%s;%sm\]" "$FG_RED"          "$BG_GREEN"
printf -v DIRECTORY_COLOR      "\[\e[%s;%sm\]" "$FG_BRIGHT_WHITE" "$BG_GREEN"
printf -v TRANSITION_COLOR_1_2 "\[\e[%s;%sm\]" "$FG_GREEN"        "$BG_MAGENTA"
printf -v GIT_COLOR            "\[\e[%s;%sm\]" "$FG_BRIGHT_WHITE" "$BG_MAGENTA"
printf -v TRANSITION_COLOR_1_3 "\[\e[%s;%sm\]" "$FG_MAGENTA"      "$BG_DEFAULT"

printf -v RETURN_CODE_COLOR    "\[\e[%sm\]"    "$FG_BRIGHT_RED"
printf -v START_COLOR_2        "\[\e[%s;%sm\]" "$FG_INVERSE"      "$FG_BLUE"
printf -v SHELL_COLOR          "\[\e[%s;%sm\]" "$FG_BRIGHT_WHITE" "$BG_BLUE"
printf -v TRANSITION_COLOR_2_1 "\[\e[%sm\]"    "$FG_BLUE"

GIT_COLOR_HINT_BG="$BG_MAGENTA"
GIT_COLOR_HINT_FG="$FG_MAGENTA"

# Commands
source "${XDG_CONFIG_HOME}/shell/git_prompt.sh"

make_ps1_prompt () {
    RETURN_CODE="$?"
    RETURN_CODE="${RETURN_CODE##0}"

    echo -n "${START_COLOR_1}${STARTER}"

    echo -n "${RESET}${USER_HOST_COLOR}"
    [[ $EUID -ne 0 ]] && echo -n " ${USER_HOST} " || echo -n " ROOT "

    echo -n "${TRANSITION_COLOR_1_1}${SEPARATOR}"
    echo -n "${DIRECTORY_COLOR} ${DIRECTORY} "

    get_git_info
    if [[ -n $GIT_INFO ]]; then
        printf -v TRANSITION_COLOR_1_2 "\[\e[%s;%sm\]" "$FG_GREEN"          "$GIT_COLOR_HINT_BG"
        printf -v GIT_COLOR            "\[\e[%s;%sm\]" "$FG_BRIGHT_WHITE"   "$GIT_COLOR_HINT_BG"
        printf -v TRANSITION_COLOR_1_3 "\[\e[%sm\]"    "$GIT_COLOR_HINT_FG"

        echo -n "${TRANSITION_COLOR_1_2}${SEPARATOR}"
        echo -n "${GIT_COLOR} ${GIT_INFO} "
        echo -n "${RESET}${TRANSITION_COLOR_1_3}${SEPARATOR}"
    else
        printf -v TRANSITION_COLOR_1_2 "\[\e[%sm\]" "$FG_GREEN"
        echo -n "${RESET}${TRANSITION_COLOR_1_2}${SEPARATOR}"
    fi

    echo -n "${BOLD}${ENDER}${RESET}${NEWLINE}"

    if [[ -n $RETURN_CODE ]]; then
        echo -n "${RETURN_CODE_COLOR}${RETURN_CODE} "
    fi

    echo -n "${RESET}${START_COLOR_2}${STARTER}"
    echo -n "${RESET}${SHELL_COLOR} ${SHELL_PROMPT} "
    echo -n "${RESET}${TRANSITION_COLOR_2_1}${SEPARATOR}${BOLD}${ENDER}${RESET} "
}

make_ps2_prompt () {
    echo -n "${START_COLOR_2}${STARTER}"
    echo -n "${SHELL_COLOR} ${SHELL_PROMPT} "
    echo -n "${RESET}${TRANSITION_COLOR_2_1}${SEPARATOR}${BOLD}${ENDER}${RESET} "
}

make_bash_prompt () {
    PS1=$(make_ps1_prompt)
    # PS1="\u@\h:\W [\s] \\$ " # Backup prompt for debugging

    printf "\033]0;%s ❯ %s@%s ❯ %s\007"\
     "${SHELL##*/}" "${USER}" "${HOSTNAME%%.*}" "${PWD/#$HOME/\~}" # Window title
}

# Final output
PROMPT_COMMAND=$(echo make_bash_prompt)

# No sense in reprogramming this with PROMPT_COMMAND
# If this ends up being dynamic, move inside make_bash_prompt as well
PS2=$(make_ps2_prompt)
