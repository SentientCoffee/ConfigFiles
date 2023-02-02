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

    echo -e "Agent started. Setting Windows SSH environment variables..."
    echo -e "--> PID:    ${SSH_AGENT_PID}"
    echo -e "--> Socket: ${SSH_AUTH_SOCK}"
    setx SSH_AGENT_PID ${SSH_AGENT_PID} > /dev/null
    setx SSH_AUTH_SOCK ${SSH_AUTH_SOCK} > /dev/null

    echo -e "\nAdding keys..."
    agent_add_keys

elif [ "${SSH_AUTH_SOCK}" ] && [ ${AGENT_RUN_STATE} = 1 ]; then
    echo -e "ssh-agent already started. Adding keys..."
    agent_add_keys
else
    echo -e "ssh-agent already started and running with keys."
fi

unset ENV
