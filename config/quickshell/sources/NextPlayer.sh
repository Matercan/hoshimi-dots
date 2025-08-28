#!/bin/bash

# Get all players into an array
players=($(playerctl -l))

# If no players found, exit
if [ ${#players[@]} -eq 0 ]; then
    echo "No players found"
    exit 1
fi

# Find the currently active player (the one that playerctl uses by default)
current_player=$(playerctl -l | head -1)  # or use playerctl metadata --format "{{playerName}}" 2>/dev/null

# Alternative way to get current player:
# current_player=$(playerctl status --format "{{playerName}}" 2>/dev/null)

# Find the index of the current player
current_index=-1
for i in "${!players[@]}"; do
    if [ "${players[$i]}" = "$current_player" ]; then
        current_index=$i
        break
    fi
done

# Calculate next index (loop to beginning if at end)
if [ $current_index -eq -1 ]; then
    # Current player not found, default to first
    next_index=0
else
    next_index=$(( (current_index + 1) % ${#players[@]} ))
fi

echo "${players[$next_index]}"
