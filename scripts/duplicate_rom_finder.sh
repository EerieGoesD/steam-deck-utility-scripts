#!/bin/bash
# Finds duplicate ROM files across all console folders and shows their locations.
# Useful for freeing up SD card space.

ROMS_DIR="/run/media/EmuDeck/Emulation/roms"

find "$ROMS_DIR" -type f \( -name "*.7z" -o -name "*.zip" -o -name "*.chd" -o -name "*.iso" -o -name "*.bin" -o -name "*.cue" \) \
  | sed 's|.*/||' \
  | sort \
  | uniq -d \
  | while read f; do
      echo "=== $f ==="
      find "$ROMS_DIR" -name "$f"
    done
