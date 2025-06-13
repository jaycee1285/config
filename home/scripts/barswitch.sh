#!/usr/bin/env bash

# Kill all running waybar instances
pkill waybar

# Restart Waybar quietly (no terminal output)
waybar >/dev/null 2>&1 &
