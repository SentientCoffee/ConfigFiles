ENV="${HOME}/.ssh/agent.env"

agent_load_env () { test -f "${ENV}" && . "${ENV}" >| /dev/null ; }

agent_start () {
    (umask 077; ssh-agent >| "${ENV}")
    source "${ENV}" >| /dev/null ;
}

agent_add_keys () {
    ssh-add "${HOME}/.ssh/id_ed25519"
    ssh-add "${HOME}/.ssh/id_ed25519_ontariotech"
}

agent_load_env

# AGENT_RUN_STATE: 0=agent running w/ key; 1=agent w/o key; 2= agent not running
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

unset ENV
