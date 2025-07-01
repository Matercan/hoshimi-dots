#!/bin/sh

AGENT_ENV_FILE="$HOME/.ssh/agent_env"
LOG_FILE="$HOME/.ssh/ssh_agent_startup.log"

echo "--- $(date): SSH Agent Startup Script Started ---" > "$LOG_FILE" 2>&1

# Try to source existing agent variables if they exist
if [ -f "$AGENT_ENV_FILE" ]; then
    echo "$(date): Sourcing existing agent file: $AGENT_ENV_FILE" >> "$LOG_FILE" 2>&1
    . "$AGENT_ENV_FILE" > /dev/null 2>&1
else
    echo "$(date): Agent env file NOT found: $AGENT_ENV_FILE" >> "$LOG_FILE" 2>&1
fi

# Check if SSH_AUTH_SOCK is set and if the agent process exists
if [ -n "$SSH_AUTH_SOCK" ] && ps -p "$SSH_AGENT_PID" > /dev/null; then
    echo "$(date): SSH Agent already running (PID: $SSH_AGENT_PID)." >> "$LOG_FILE" 2>&1
else
    echo "$(date): Starting SSH Agent..." >> "$LOG_FILE" 2>&1
    # Start the agent and capture its output, redirecting all output to agent_env and log
    # Crucially, we pipe through grep to remove the "Agent pid" line for Fish compatibility
    if eval "$(ssh-agent -s | grep -v 'Agent pid')" > "$AGENT_ENV_FILE" 2>> "$LOG_FILE"; then
        echo "$(date): SSH Agent started successfully. PID: $SSH_AGENT_PID" >> "$LOG_FILE" 2>&1
        chmod 600 "$AGENT_ENV_FILE" # Secure the file
    else
        echo "$(date): ERROR: Failed to start SSH Agent via eval." >> "$LOG_FILE" 2>&1
    fi
fi

# Check if the key is already added to the agent
if ! ssh-add -l > /dev/null 2>&1; then
    echo "$(date): Adding SSH key..." >> "$LOG_FILE" 2>&1
    ssh-add ~/.ssh/id_ed25519 < /dev/null >> "$LOG_FILE" 2>&1
    if [ $? -eq 0 ]; then
        echo "$(date): SSH key added successfully." >> "$LOG_FILE" 2>&1
    else
        echo "$(date): ERROR: Failed to add SSH key. Check passphrase or permissions." >> "$LOG_FILE" 2>&1
    fi
else
    echo "$(date): SSH key already added." >> "$LOG_FILE" 2>&1
fi

# Ensure environment variables are exported for the current shell context
export SSH_AUTH_SOCK
export SSH_AGENT_PID

echo "$(date): SSH Agent setup complete." >> "$LOG_FILE" 2>&1
