#!/bin/bash
# Searches the Steam Deck for leftover Decky Loader files after uninstall.

echo "Searching for Decky Loader leftovers..."
echo ""

found=0

check() {
  local label="$1"
  shift
  while IFS= read -r file; do
    if (( found == 0 )); then
      echo "=== Decky Loader leftovers found ==="
    fi
    size=$(du -h "$file" 2>/dev/null | cut -f1)
    echo "  [$size]  $file"
    ((found++))
  done < <("$@" 2>/dev/null)
}

# Known Decky paths
KNOWN_PATHS=(
  "/home/deck/homebrew"
  "/home/deck/.local/share/decky"
  "/home/deck/.config/decky"
  "/home/deck/.steam/steam/.cef-enable-remote-debugging"
  "/etc/systemd/system/plugin_loader.service"
  "/etc/systemd/system/multi-user.target.wants/plugin_loader.service"
)

for path in "${KNOWN_PATHS[@]}"; do
  if [ -e "$path" ]; then
    if (( found == 0 )); then
      echo "=== Decky Loader leftovers found ==="
    fi
    if [ -d "$path" ]; then
      size=$(du -sh "$path" 2>/dev/null | cut -f1)
      echo "  [$size]  $path/"
    else
      size=$(du -h "$path" 2>/dev/null | cut -f1)
      echo "  [$size]  $path"
    fi
    ((found++))
  fi
done

# Search for any remaining files/dirs with "decky" in the name
check "decky name search" find /home/deck /tmp /etc -iname "*decky*" \
  -not -path "/home/deck/Documents/GitHub/steam-deck-utility-scripts/*"

# Search for plugin_loader references
check "plugin_loader search" find /home/deck /etc /tmp -iname "*plugin_loader*"

if (( found == 0 )); then
  echo "No Decky Loader leftovers found. Clean uninstall!"
else
  echo ""
  echo "Found $found leftover(s)."
fi

read -p "Press Enter to close..."
