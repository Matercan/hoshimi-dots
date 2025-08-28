#!/bin/bash

# Get the first player that is currently playing
first_playing=$(playerctl -l | while read player; do
    status=$(playerctl -p "$player" status 2>/dev/null)
    if [ "$status" = "Playing" ]; then
        echo "$player"
        break
    fi
done)

if [ -n "$first_playing" ]; then
    echo "$first_playing"
else
    echo "null"
    exit 1
fi
