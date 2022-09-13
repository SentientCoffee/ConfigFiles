ENV="${HOME}/.ssh/agent.env"

agent_load_env () { test -f "${ENV}" && . "${ENV}" >| /dev/null ; }

agent_start () {
    (umask 077; ssh-agent >| "${ENV}")
    . "${ENV}" >| /dev/null ;
}

agent_load_env

# agent_run_state: 0=agent running w/ key; 1=agent w/o key; 2= agent not running
AGENT_RUN_STATE=$(ssh-add -l >| /dev/null 2>&1; echo $?)

if [ ! "$SSH_AUTH_SOCK" ] || [ $AGENT_RUN_STATE = 2 ]; then
    echo -e "===== Starting ssh-agent ====="
    agent_start

    echo -e "===== Adding keys ====="
    ssh-add ${HOME}/.ssh/id_ed25519
    ssh-add ${HOME}/.ssh/id_ed25519_ontariotech
elif [ "$SSH_AUTH_SOCK" ] && [ $AGENT_RUN_STATE = 1 ]; then
    echo -e "ssh-agent already started.\n===== Adding keys ====="
    ssh-add ${HOME}/.ssh/id_ed25519
    ssh-add ${HOME}/.ssh/id_ed25519_ontariotech
fi

unset env
