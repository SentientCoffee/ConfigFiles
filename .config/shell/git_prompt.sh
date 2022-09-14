BRANCH_ICON=""
STATUS_CLEAN=""
STATUS_SEPARATOR="❯"

UNTRACKED_SYMBOL=""
UNSTAGED_SYMBOL=""
STAGED_SYMBOL=""

get_git_info () {
    BRANCH=$(git branch --no-color 2>/dev/null | grep '*' | awk '{print $2}')
    STATUS=$(git status --porcelain 2>/dev/null)

    OUT="${BRANCH_ICON} ${BRANCH}"

    SYMBOLS=""

    STAGED=$(grep -E "^[ACDMR]" <<< "$STATUS" | wc -l)
    UNSTAGED=$(grep -E "^.[DM]" <<< "$STATUS" | wc -l)
    UNTRACKED=$(grep -E "^\?"   <<< "$STATUS" | wc -l)

    [[ STAGED    -gt 0 ]] && SYMBOLS+=" ${STAGED_SYMBOL} ${STAGED}"
    [[ UNSTAGED  -gt 0 ]] && SYMBOLS+=" ${UNSTAGED_SYMBOL} ${UNSTAGED}"
    [[ UNTRACKED -gt 0 ]] && SYMBOLS+=" ${UNTRACKED_SYMBOL} ${UNTRACKED}"

    SYMBOLS="${SYMBOLS:- ${STATUS_CLEAN}}"
    OUT+="${SYMBOLS:+ ${STATUS_SEPARATOR}${SYMBOLS}}"
    GIT_INFO="${BRANCH:+${OUT}}"
}

export GIT_INFO=""
