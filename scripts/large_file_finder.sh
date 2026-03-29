#!/bin/bash
# Finds the largest files and directories on the Steam Deck, sorted by size.

ROMS_DIRS=(
  "/home/deck/Emulation/roms"
  "/run/media/deck/EmuDeck/Emulation/roms"
)

# Exclude ROMs?
echo "Exclude ROMs folders from results?"
for dir in "${ROMS_DIRS[@]}"; do
  echo "  $dir"
done
read -p "(y/N): " exclude_roms

# Files or directories?
echo ""
echo "What do you want to find?"
echo "  1) Largest files only"
echo "  2) Largest directories only"
echo "  3) Both"
read -p "Choice (1/2/3): " mode

# How many results?
echo ""
read -p "Show top how many results? [50]: " count
count=${count:-50}

echo ""
echo "Scanning... (this may take a moment)"
echo ""
echo "=== Largest items ==="
echo ""

# Build prune args for find/du
PRUNE_ARGS=()
if [[ "$exclude_roms" =~ ^[Yy]$ ]]; then
  for dir in "${ROMS_DIRS[@]}"; do
    PRUNE_ARGS+=(-path "$dir" -prune -o)
  done
fi

case "$mode" in
  1)
    # Files only: find with prune, print files, du -h each batch
    find /home/deck /run/media/deck "${PRUNE_ARGS[@]}" -type f -print0 2>/dev/null \
      | xargs -0 du -h 2>/dev/null \
      | sort -rh | head -"$count"
    ;;
  2)
    # Directories only: du -d1 on top-level, then sort
    {
      for dir in /home/deck /run/media/deck; do
        if [[ "$exclude_roms" =~ ^[Yy]$ ]]; then
          du -h --max-depth=3 "$dir" 2>/dev/null | grep -Ev "$(printf '%s|' "${ROMS_DIRS[@]}" | sed 's/|$//')"
        else
          du -h --max-depth=3 "$dir" 2>/dev/null
        fi
      done
    } | sort -rh | head -"$count"
    ;;
  *)
    # Both
    {
      if [[ "$exclude_roms" =~ ^[Yy]$ ]]; then
        du -ah /home/deck /run/media/deck 2>/dev/null | grep -Ev "$(printf '%s|' "${ROMS_DIRS[@]}" | sed 's/|$//')"
      else
        du -ah /home/deck /run/media/deck 2>/dev/null
      fi
    } | sort -rh | head -"$count"
    ;;
esac

echo ""
read -p "Press Enter to close..."
