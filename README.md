# Resizing-Intuos-Pro-L
These scripts resize an Intuos Pro L Graphic Tablet to the M size of FregoM. One is to get a 16:10 resolution and the  other one to get a  16:9 resolution. The last script is to restore the native size of the Intuos Pro L

## Scripts

- **`wacom_frego_resize16x10.sh`**  
  Sets the tablet active area to **254 × 158.8 mm** (≈ **16:10**), anchored to the bottom-left of the physical tablet.

- **`wacom_frego_resize16x9.sh`**  
  Sets the tablet active area to **254 mm width** with a **16:9 height** (**142.875 mm**), anchored to the bottom-left.

- **`wacom_reset.sh`**  
  Restores the full active area.

All scripts:
- Target only devices matching `Intuos Pro L` and `stylus`.
- Use `xsetwacom` to set the Area
- Pop a desktop notification with `notify-send`

## Requirements

- `xsetwacom` (usually from `xserver-xorg-input-wacom`)
- `notify-send` (usually from `libnotify-bin`)
- An X11 session / environment where `xsetwacom` works

## Install / run

```bash
chmod +x wacom_*.sh
./wacom_frego_resize16x10.sh
./wacom_frego_resize16x9.sh
./wacom_reset.sh

## Shorcut

Store the .sh file in /home/ldc/.local/bin  and in `Custom Shortcut`add a shortcut with `+` give for example:
  - *Name*: Wacom Resize FregoM16x9
  - *Command: /home/ldc/.local/bin/wacom_frego_resize16x9.sh 
  - Shortcut: Alt + N

