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
echo "=== Largest items ==="
echo ""

# Build exclude args for grep
EXCLUDE_PATTERN=""
if [[ "$exclude_roms" =~ ^[Yy]$ ]]; then
  for dir in "${ROMS_DIRS[@]}"; do
    if [ -z "$EXCLUDE_PATTERN" ]; then
      EXCLUDE_PATTERN="$dir"
    else
      EXCLUDE_PATTERN="$EXCLUDE_PATTERN|$dir"
    fi
  done
fi

# Pick du flags based on mode
case "$mode" in
  1) du_flags="-ah --max-depth=0" ; use_find=true ;;
  2) du_flags="-h --max-depth=5" ; use_find=false ;;
  *) du_flags="-ah" ; use_find=false ;;
esac

if $use_find 2>/dev/null; then
  # Files only: use find to list files, then du each
  {
    find /home/deck /run/media/deck -type f 2>/dev/null
  } | while IFS= read -r f; do
    du -h "$f" 2>/dev/null
  done | {
    if [ -n "$EXCLUDE_PATTERN" ]; then
      grep -Ev "$EXCLUDE_PATTERN"
    else
      cat
    fi
  } | sort -rh | head -"$count"
else
  du $du_flags /home/deck /run/media/deck 2>/dev/null | {
    if [ -n "$EXCLUDE_PATTERN" ]; then
      grep -Ev "$EXCLUDE_PATTERN"
    else
      cat
    fi
  } | sort -rh | head -"$count"
fi

echo ""
read -p "Press Enter to close..."
