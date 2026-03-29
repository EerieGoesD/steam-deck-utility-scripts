#!/bin/bash
# Removes known clutter files from the Steam Deck.
# Shows each item and asks for confirmation before deleting.

TARGETS=(
  "/home/deck/fresh.flatpak"
  "/home/deck/com.eerie.readervaultpro.flatpak"
  "/home/deck/Applications/ES-DE.AppImage_3.3.0.OLD"
  "/home/deck/deck-toolbox/.flatpak-builder"
  "/home/deck/yay/src/gopath/pkg/mod/cache"
  "/home/deck/.local/share/ULWGL/ULWGL-launcher.tar.gz"
  "/home/deck/.cache/winetricks/directx9"
  "/run/media/deck/EmuDeck/Emulation/bios/Citron-0.7.1-anylinux-x86_64.AppImage"
)

echo "=== Steam Deck Declutter ==="
echo ""

deleted=0
freed=0

for path in "${TARGETS[@]}"; do
  if [ -e "$path" ]; then
    if [ -d "$path" ]; then
      size=$(du -sh "$path" 2>/dev/null | cut -f1)
      echo "  [$size]  $path/"
    else
      size=$(du -h "$path" 2>/dev/null | cut -f1)
      echo "  [$size]  $path"
    fi
    read -p "  Delete? (y/N): " confirm
    if [[ "$confirm" =~ ^[Yy]$ ]]; then
      rm -rf "$path"
      echo "  Deleted."
      ((deleted++))
    else
      echo "  Kept."
    fi
    echo ""
  fi
done

if (( deleted == 0 )); then
  echo "Nothing was deleted."
else
  echo "Deleted $deleted item(s)."
fi

read -p "Press Enter to close..."
