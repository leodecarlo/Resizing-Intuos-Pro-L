#!/bin/bash

# ==============================================================================
# WACOM RESIZER: Frego M Width @ 16:9 Ratio (Bottom-Left Anchor)
# Width:  254mm (Same as Frego M)
# Height: 142.875mm (Calculated for 16:9 Aspect Ratio)
# Wacom Resolution: 200 lines per mm
# ==============================================================================

# 1. DEFINE TARGET DIMENSIONS IN COUNTS
# Width:  254mm   * 200 = 50800
# Height: 142.875 * 200 = 28575
TARGET_W_COUNTS=50800
TARGET_H_COUNTS=28575

# 2. FUNCTION TO CONFIGURE A DEVICE
configure_tablet() {
    DEVICE_ID=$1
    DEVICE_NAME=$2

    # Reset area to defaults first
    xsetwacom set "$DEVICE_ID" ResetArea

    # Get the tablet's full area (Max Y is the 4th value)
    AREA_INFO=$(xsetwacom get "$DEVICE_ID" Area)
    TABLET_MAX_Y=$(echo "$AREA_INFO" | awk '{print $4}')

    # 3. CALCULATE COORDINATES (Bottom-Left Anchor)
    # X starts at 0
    # Y starts at (Max_Y - Target_Height)
    
    NEW_MIN_X=0
    NEW_MIN_Y=$((TABLET_MAX_Y - TARGET_H_COUNTS))
    NEW_MAX_X=$TARGET_W_COUNTS
    NEW_MAX_Y=$TABLET_MAX_Y

    # Safety check
    if [ "$NEW_MIN_Y" -lt 0 ]; then
        NEW_MIN_Y=0
    fi

    # 4. APPLY SETTINGS
    xsetwacom set "$DEVICE_ID" Area "$NEW_MIN_X" "$NEW_MIN_Y" "$NEW_MAX_X" "$NEW_MAX_Y"
}

# 5. FIND DEVICES AND RUN
# Filter strictly for "Intuos Pro L"
xsetwacom --list devices | grep "Intuos Pro L" | grep "stylus" | while read -r line; do
    ID=$(echo "$line" | grep -o 'id: [0-9]*' | awk '{print $2}')
    NAME=$(echo "$line" | cut -d ':' -f1 | sed 's/[[:space:]]*$//')
    
    configure_tablet "$ID" "$NAME"
done

# 6. SEND NOTIFICATION
notify-send "Wacom Resize" "Activated Frego M Width (16:9 Ratio)" --icon=input-tablet