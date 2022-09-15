# Foreground colors
BLACK="0"
RED="1"
GREEN="2"
YELLOW="3"
BLUE="4"
MAGENTA="5"
CYAN="6"
WHITE="7"

# Foreground bright colors
BRIGHT_BLACK="8"
BRIGHT_RED="9"
BRIGHT_GREEN="10"
BRIGHT_YELLOW="11"
BRIGHT_BLUE="12"
BRIGHT_MAGENTA="13"
BRIGHT_CYAN="14"
BRIGHT_WHITE="15"

# Symbols
CURRENT_TTY=$(print -P "%y")
if [[ ${CURRENT_TTY%/*} == "pts" ]]; then
    STARTER_L=""   ; STARTER_R=""    # \U00e0b0 ; \U00e0b2
    SEPARATOR_L="" ; SEPARATOR_R=""  # \U00e0b0 ; \U00e0b2
    ENDER_L=""     ; ENDER_R=""      # \U00e0b1 ; \U00e0b3
else
    STARTER_L=""   ; STARTER_R=""
    SEPARATOR_L="" ; SEPARATOR_R=""
    ENDER_L=""     ; ENDER_R=""
fi

# Special sequences
NEWLINE="\n"
USER_HOST="%n@%M"
DIRECTORY="%~"
SHELL_PROMPT="${ZSH_NAME} %#"

# Color combos
RESET="%f%k%b%s"
BOLD="%B"
INVERSE="%S"

GIT_COLOR_HINT="$MAGENTA"

printf -v START_COLOR_1        "%%F{%s}"        "$RED"
printf -v USER_HOST_COLOR      "%%F{%s}%%K{%s}" "$BRIGHT_WHITE"   "$RED"
printf -v TRANSITION_COLOR_1_1 "%%F{%s}%%K{%s}" "$RED"            "$GREEN"
printf -v DIRECTORY_COLOR      "%%F{%s}%%K{%s}" "$BRIGHT_WHITE"   "$GREEN"
printf -v TRANSITION_COLOR_1_2 "%%F{%s}"        "$GREEN"

printf -v TRANSITION_COLOR_1_3 "%%F{%s}"        "$GIT_COLOR_HINT"
printf -v GIT_COLOR            "%%F{%s}%%K{%s}" "$BRIGHT_WHITE"   "$GIT_COLOR_HINT"
printf -v TRANSITION_COLOR_1_4 "%%F{%s}"        "$GIT_COLOR_HINT"

printf -v RETURN_CODE_COLOR    "%%F{%s}%%K{%s}" "$BRIGHT_RED"   "$BLACK"
printf -v START_COLOR_2        "%%F{%s}"        "$BLUE"
printf -v SHELL_COLOR          "%%F{%s}%%K{%s}" "$BRIGHT_WHITE" "$BLUE"
printf -v TRANSITION_COLOR_2_1 "%%F{%s}"        "$BLUE"

# Commands
source "${XDG_CONFIG_HOME}/shell/git_prompt.sh"

make_top_ps1_prompt () {
    print -n "${INVERSE}${START_COLOR_1}${STARTER_L}"

    print -n "${RESET}${USER_HOST_COLOR}"
    [[ ${EUID} -ne 0 ]] && print -n " ${USER_HOST} " || print -n " ROOT "

    print -n "${TRANSITION_COLOR_1_1}${SEPARATOR_L}"
    print -n "${DIRECTORY_COLOR} ${DIRECTORY} "

    print -n "${RESET}${TRANSITION_COLOR_1_2}${SEPARATOR_L}"

    print -n "${BOLD}${ENDER_L}${RESET}"
}

make_top_rps1_prompt () {
    print -n "${TRANSITION_COLOR_1_3}${ENDER_R}${SEPARATOR_R}"

    get_git_info
    if [[ -n ${GIT_INFO} ]]; then
        print -n "${GIT_COLOR} ${GIT_INFO}"
    else
        print -n "${GIT_COLOR}  "
    fi

    print -n "${RESET}${INVERSE}${TRANSITION_COLOR_1_4} ${STARTER_R}${RESET}"
}

make_bottom_ps1_prompt () {
    print -n "${INVERSE}${START_COLOR_2}${STARTER_L}"
    print -n "${RESET}${SHELL_COLOR} ${SHELL_PROMPT} "
    print -n "${RESET}${TRANSITION_COLOR_2_1}${SEPARATOR_L}${BOLD}${ENDER_L}${RESET} "
}

make_bottom_rps1_prompt () {
    TRANSITION_COLOR_2_2="%F{%0(?.$GREEN.$RED)}"
    RETURN_CODE_COLOR="%F{$BRIGHT_WHITE}%K{%0(?.$GREEN.$RED)}"
    TRANSITION_COLOR_2_3="%F{%0(?.$GREEN.$RED)}"

    print -n "${RESET}${TRANSITION_COLOR_2_2}${ENDER_R}${SEPARATOR_R}"
    print -n "${RESET}${RETURN_CODE_COLOR} %? "
    print -n "${RESET}${INVERSE}${TRANSITION_COLOR_2_3}${STARTER_R}"
}

make_ps2_prompt () {
    make_bottom_ps1_prompt
}

make_rps2_prompt () {

}

prompt_length () {
    emulate -L zsh

    local -i COLUMNS=${2:-COLUMNS}
    local -i x y=${#1} m

    if (( y )); then
        while (( ${${(%):-$1%$y(l.1.0)}[-1]} )); do
            x=y
            (( y *= 2 ))
        done
        while (( y > x + 1 )); do
            (( m = x + (y - x) / 2 ))
            (( ${${(%):-$1%$m(l.x.y)}[-1]} = m ))
        done
    fi

    typeset -g RETURN=${x}
}

fill_line () {
    emulate -L zsh

    prompt_length $1
    local -i left_len=RETURN

    prompt_length $2 9999
    local -i right_len=RETURN

    local -i pad_len=$((COLUMNS - left_len - right_len - ${ZLE_RPROMPT_INDENT:-1}))
    if (( pad_len < 1 )); then
        # Not enough space for the right part. Drop it.
        typeset -g RETURN=$1
    else
        local pad=${(pl.$pad_len.. .)}  # pad_len spaces
        typeset -g RETURN=${1}${pad}${2}
    fi
}

make_zsh_prompt () {
    local p1_t="$(make_top_ps1_prompt)"
    local p1_b="%B%F{blue}%#%f%b "
    local rp1="[%B%F{%0(?.green.red)}%?%f%b]"

    local RETURN
    fill_line "$(make_top_ps1_prompt)" "$(make_top_rps1_prompt)"
    PS1="${RETURN}"$'\n'"$(make_bottom_ps1_prompt)"
    RPS1=$(make_bottom_rps1_prompt)
    PS2=$(make_ps2_prompt)

    # RPS1=$(make_rps1_prompt)

    # Backup prompts for debugging
    # PS1="%B%F{${RED}}%n%f%b@%B%F{${RED}}%M%f%b %B%F{${GREEN}}%~%f%b %B%F{${BLUE}}%#%f%b "
    # PS2="%F{${YELLOW}}%_ %B%F{${BLUE}}%#%f%b "
    # RPS1="[%B%F{%0(?.${GREEN}.${RED})}%?%f%b]"
    # RPS2="[%B%F{%0(?.${GREEN}.${RED})}%^%f%b]"

    local CURRENT_DIR="${PWD/#${HOME}/\~}"
    local CURRENT_DIR="${HOME_DIR#\\}"

    # Window title
    printf "\033]0;%s ❯ %s@%s ❯ %s\007"   "${SHELL##*/}" "${USER}" "${HOSTNAME%%.*}${HOST%%.*}" "${CURRENT_DIR}"
}

# Final output
add-zsh-hook -Uz precmd make_zsh_prompt

