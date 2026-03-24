#!/bin/bash
# Finds duplicate ROM files across all console folders and shows their locations.
# Useful for freeing up SD card space.
# Uses normalized filenames to catch near-duplicates (punctuation, case, spacing differences).
 
ROMS_DIR="/run/media/EmuDeck/Emulation/roms"
 
declare -A seen
 
while IFS= read -r filepath; do
  filename="${filepath##*/}"
  # Normalize: lowercase, strip punctuation, collapse whitespace
  key=$(echo "$filename" | tr '[:upper:]' '[:lower:]' | sed "s/[^a-z0-9 ]/ /g" | tr -s ' ')
  seen["$key"]+="$filepath"$'\n'
done < <(find "$ROMS_DIR" -type f \( -name "*.7z" -o -name "*.zip" -o -name "*.chd" -o -name "*.iso" -o -name "*.bin" -o -name "*.cue" \))
 
for key in "${!seen[@]}"; do
  count=$(echo -n "${seen[$key]}" | grep -c '^')
  if (( count > 1 )); then
    echo "=== Possible duplicates (normalized: $key) ==="
    echo -n "${seen[$key]}"
    echo ""
  fi
done
