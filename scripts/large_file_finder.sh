#!/bin/bash
# Finds the largest files and directories on the Steam Deck, sorted by size.

echo "=== Largest files and directories ==="
echo ""
du -ah /home/deck /run/media/deck 2>/dev/null | sort -rh | head -50
echo ""

read -p "Press Enter to close..."
