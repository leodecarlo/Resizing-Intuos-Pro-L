#!/bin/bash

# ==============================================================================
# WACOM RESET: Restore Full Active Area
# ==============================================================================

# Find "Intuos Pro L" stylus and reset it
xsetwacom --list devices | grep "Intuos Pro L" | grep "stylus" | while read -r line; do
    # Extract ID
    ID=$(echo "$line" | grep -o 'id: [0-9]*' | awk '{print $2}')
    
    # Reset Area to defaults (Full Tablet)
    xsetwacom set "$ID" ResetArea
done

# Send Notification
notify-send "Wacom Reset" "Tablet restored to full active area" --icon=input-tablet
