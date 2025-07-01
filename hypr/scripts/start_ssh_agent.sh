#!/bin/sh

# Check if SSH_AUTH_SOCK is set (agent is likely running)
# and if the agent process exists
if [ -n "$SSH_AUTH_SOCK" ] && ps -p "$SSH_AGENT_PID" > /dev/null; then
    echo "SSH Agent already running."
else
    # Start the agent and capture its output
    eval "$(ssh-agent -s)" > ~/.ssh/agent_env
    echo "SSH Agent started. PID: $SSH_AGENT_PID"
    # Add key on first start
    ssh-add ~/.ssh/id_ed25519 < /dev/null # < /dev/null prevents blocking on passphrase if launched without tty
fi

# Make agent variables available to other shells later
chmod 600 ~/.ssh/agent_env
