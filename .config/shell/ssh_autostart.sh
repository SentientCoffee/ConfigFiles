SSH_ENV="${HOME}/.ssh/agent.env"

agent_load_env () {
    test -f "${SSH_ENV}" && source "${SSH_ENV}" >| /dev/null;
}

agent_start () {
    (umask 077; ssh-agent >| "${SSH_ENV}")
    source "${SSH_ENV}" >| /dev/null ;
}

agent_add_keys () {
    ssh-add "${HOME}/.ssh/id_ed25519_github"
    ssh-add "${HOME}/.ssh/id_ed25519_github_otu"
    ssh-add "${HOME}/.ssh/id_ed25519_rpi"
    ssh-add "${HOME}/.ssh/id_ed25519_brix"
}

# ---------------------------------------------------

agent_load_env

# 0 = agent running w/ key
# 1 = agent w/o key
# 2 = agent not running
AGENT_RUN_STATE=$(ssh-add -l >| /dev/null 2>&1; echo $?)

echo "---------- Starting ssh-agent ----------"
if [ ! "${SSH_AUTH_SOCK}" ] || [ ${AGENT_RUN_STATE} = 2 ]; then
    agent_start
    echo "Agent started. Adding keys..."
    agent_add_keys

elif [ "${SSH_AUTH_SOCK}" ] && [ ${AGENT_RUN_STATE} = 1 ]; then
    echo -e "ssh-agent already started. Adding keys..."
    agent_add_keys

else
    echo "ssh-agent already running with keys."

fi

unset SSH_ENV
