#!/usr/bin/env bash

# Use `date` to format without leading 0
time=$(date +"%-l:%M %p" | sed 's/  / /g') # Handles space before single-digit hour

echo "{\"text\": \"$time\", \"tooltip\": \"$(date '+%A, %B %d, %Y')\"}"
