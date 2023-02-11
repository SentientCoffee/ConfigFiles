#!/bin/sh

BRANCH_ICON=""
STATUS_CLEAN=""
STATUS_SEPARATOR="❯"

UNTRACKED_SYMBOL="?"
UNSTAGED_SYMBOL=""
STAGED_SYMBOL="⟰"

AHEAD_SYMBOL=""
BEHIND_SYMBOL=""

get_git_info () {
    STATUS=$(git status --porcelain --branch 2>/dev/null)
    [ -z "${STATUS}" ] && return

    BRANCH=$(echo "${STATUS}" | grep -e '##' | sed -r 's/^##\s([^.]+).*/\1/')
    AHEAD=$(echo "${STATUS}" | grep -E '##.*ahead' | sed -r 's/.*ahead ([0-9]+).*/\1/')
    BEHIND=$(echo "${STATUS}" | grep -E '##.*behind' | sed -r 's/.*behind ([0-9]+).*/\1/')

    [ -n "${AHEAD}"  ] && BRANCH="${BRANCH} ${AHEAD_SYMBOL} ${AHEAD}"
    [ -n "${BEHIND}" ] && BRANCH="${BRANCH} ${BEHIND_SYMBOL} ${BEHIND}"

    OUT="${BRANCH_ICON} ${BRANCH}"

    SYMBOLS=""

    STAGED=$(echo "${STATUS}" | grep -c -E "^[ACDMR]")
    UNSTAGED=$(echo "${STATUS}" | grep -c -E "^.[DM]")
    UNTRACKED=$(echo "${STATUS}" | grep -c -E "^\?")

    [ "${STAGED}"    -gt 0 ] && SYMBOLS="${SYMBOLS} ${STAGED_SYMBOL} ${STAGED}"
    [ "${UNSTAGED}"  -gt 0 ] && SYMBOLS="${SYMBOLS} ${UNSTAGED_SYMBOL} ${UNSTAGED}"
    [ "${UNTRACKED}" -gt 0 ] && SYMBOLS="${SYMBOLS} ${UNTRACKED_SYMBOL} ${UNTRACKED}"

    SYMBOLS="${SYMBOLS:- ${STATUS_CLEAN}}"
    OUT="${OUT}${SYMBOLS:+ ${STATUS_SEPARATOR}${SYMBOLS}}"
    echo "${BRANCH:+${OUT}}"
}
