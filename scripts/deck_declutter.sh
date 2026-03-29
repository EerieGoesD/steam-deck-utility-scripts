#!/bin/bash
# Removes known clutter files from the Steam Deck.

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

# Show what was found
found=()
for path in "${TARGETS[@]}"; do
  if [ -e "$path" ]; then
    found+=("$path")
    if [ -d "$path" ]; then
      size=$(du -sh "$path" 2>/dev/null | cut -f1)
      echo "  [$size]  $path/"
    else
      size=$(du -h "$path" 2>/dev/null | cut -f1)
      echo "  [$size]  $path"
    fi
  fi
done

if (( ${#found[@]} == 0 )); then
  echo "No clutter found."
  read -p "Press Enter to close..."
  exit 0
fi

echo ""
echo "Delete [a]ll, prompt [i]ndividually, or [c]ancel?"
read -p "Choice (a/i/c): " mode

deleted=0

case "$mode" in
  a|A)
    for path in "${found[@]}"; do
      rm -rf "$path"
      echo "  Deleted: $path"
      ((deleted++))
    done
    ;;
  i|I)
    for path in "${found[@]}"; do
      read -p "  Delete $path? (y/N): " confirm
      if [[ "$confirm" =~ ^[Yy]$ ]]; then
        rm -rf "$path"
        echo "    Deleted."
        ((deleted++))
      else
        echo "    Kept."
      fi
    done
    ;;
  *)
    echo "Cancelled."
    read -p "Press Enter to close..."
    exit 0
    ;;
esac

echo ""
echo "Deleted $deleted item(s)."

read -p "Press Enter to close..."
