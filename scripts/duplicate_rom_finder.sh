#!/bin/bash
# Finds duplicate ROM files within each console folder and shows their locations.
# Useful for freeing up SD card space.
# Uses normalized filenames to catch near-duplicates (punctuation, case, spacing differences).
# Only flags duplicates within the same console/subfolder (e.g. psx, ps2 are separate).

ROMS_DIR="/run/media/EmuDeck/Emulation/roms"

declare -A seen

while IFS= read -r filepath; do
  filename="${filepath##*/}"
  # Get the console folder (first subfolder under ROMS_DIR)
  console=$(echo "$filepath" | sed "s|^$ROMS_DIR/||" | cut -d'/' -f1)
  # Normalize: lowercase, strip punctuation, collapse whitespace
  norm=$(echo "$filename" | tr '[:upper:]' '[:lower:]' | sed "s/[^a-z0-9 ]/ /g" | tr -s ' ')
  key="${console}|${norm}"
  seen["$key"]+="$filepath"$'\n'
done < <(find "$ROMS_DIR" -type f \( -name "*.7z" -o -name "*.zip" -o -name "*.chd" -o -name "*.iso" -o -name "*.bin" -o -name "*.cue" \))

for key in "${!seen[@]}"; do
  count=$(echo -n "${seen[$key]}" | grep -c '^')
  if (( count > 1 )); then
    console="${key%%|*}"
    norm="${key#*|}"
    echo "=== [$console] Possible duplicates (normalized: $norm) ==="
    echo -n "${seen[$key]}"
    echo ""
  fi
done
