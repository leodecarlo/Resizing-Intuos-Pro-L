#!/bin/bash

# ==============================================================================
# WACOM RESIZER: Target Frego M Size (Bottom-Left Anchor)
# Target Physical Size: 254mm x 158.8mm
# Wacom Resolution: 200 lines per mm (5080 lpi)
# ==============================================================================

# 1. DEFINE TARGET DIMENSIONS IN COUNTS
# Width:  254mm   * 200 = 50800
# Height: 158.8mm * 200 = 31760
TARGET_W_COUNTS=50800
TARGET_H_COUNTS=31760

# 2. FUNCTION TO CONFIGURE A DEVICE
configure_tablet() {
    DEVICE_ID=$1
    DEVICE_NAME=$2

    # Reset area to defaults first to ensure we read the true physical max
    xsetwacom set "$DEVICE_ID" ResetArea

    # Get the tablet's full area. Output format is: "min_x min_y max_x max_y"
    AREA_INFO=$(xsetwacom get "$DEVICE_ID" Area)
    
    # We only need the Max Y (the 4th value) to calculate the bottom anchor
    TABLET_MAX_Y=$(echo "$AREA_INFO" | awk '{print $4}')
    
    # 3. CALCULATE COORDINATES
    # Bottom-Left Anchor Logic:
    # X starts at 0 (Left)
    # Y starts at (Max_Y - Target_Height) to touch the bottom edge.

    NEW_MIN_X=0
    NEW_MIN_Y=$((TABLET_MAX_Y - TARGET_H_COUNTS))
    NEW_MAX_X=$TARGET_W_COUNTS
    NEW_MAX_Y=$TABLET_MAX_Y

    # Safety check: Prevent negative numbers if the target is larger than the tablet
    if [ "$NEW_MIN_Y" -lt 0 ]; then
        NEW_MIN_Y=0
    fi

    # 4. APPLY SETTINGS
    xsetwacom set "$DEVICE_ID" Area "$NEW_MIN_X" "$NEW_MIN_Y" "$NEW_MAX_X" "$NEW_MAX_Y"
}

# 5. FIND DEVICES AND RUN
# Filter strictly for "Intuos Pro L" (to capture the external tablet)
# AND "stylus" (to avoid the eraser, touch, or pad for now)
FOUND=false
xsetwacom --list devices | grep "Intuos Pro L" | grep "stylus" | while read -r line; do
    # Extract ID
    ID=$(echo "$line" | grep -o 'id: [0-9]*' | awk '{print $2}')
    # Extract Name
    NAME=$(echo "$line" | cut -d ':' -f1 | sed 's/[[:space:]]*$//')
    
    configure_tablet "$ID" "$NAME"
    FOUND=true
done

# 6. SEND NOTIFICATION
# This creates a pop-up bubble on your desktop
notify-send "Wacom Resize" "Activated Frego M size 16x10" --icon=input-tablet