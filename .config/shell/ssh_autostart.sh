ENV="${HOME}/.ssh/agent.env"

agent_load_env () { test -f "${ENV}" && . "${ENV}" >| /dev/null ; }

agent_start () {
    (umask 077; ssh-agent >| "${ENV}")
    . "${ENV}" >| /dev/null ;
}

agent_add_keys () {
    ssh-add "${HOME}/.ssh/id_ed25519"
    ssh-add "${HOME}/.ssh/id_ed25519_ontariotech"
    ssh-add "${HOME}/.ssh/id_ed25519_dbs-mkm"
    ssh-add "${HOME}/.ssh/id_ed25519_gerrit"
}

agent_load_env

# AGENT_RUN_STATE: 0=agent running w/ key; 1=agent w/o key; 2= agent not running
AGENT_RUN_STATE=$(ssh-add -l >| /dev/null 2>&1; echo $?)

echo -e "---------- Starting ssh-agent ----------"
if [ ! "${SSH_AUTH_SOCK}" ] || [ ${AGENT_RUN_STATE} = 2 ]; then
    agent_start
    echo -e "Agent started."

    echo -e "\n---------- Adding keys ----------"
    agent_add_keys

    echo -e "\n---------- Setting Windows SSH environment variables ----------"
    echo -e "PID: ${SSH_AGENT_PID} | Socket: ${SSH_AUTH_SOCK})"
    setx SSH_AGENT_PID ${SSH_AGENT_PID}
    setx SSH_AUTH_SOCK ${SSH_AUTH_SOCK}

elif [ "${SSH_AUTH_SOCK}" ] && [ ${AGENT_RUN_STATE} = 1 ]; then
    echo -e "ssh-agent already started."
    echo -e "\n---------- Adding keys ----------"
    agent_add_keys
fi

unset ENV
