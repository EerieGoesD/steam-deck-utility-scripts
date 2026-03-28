#!/bin/bash
# Finds ROM files that may be lost outside of the standard EmuDeck roms directories.
# Searches common Steam Deck locations while skipping known roms paths,
# system directories, and other irrelevant locations.

KNOWN_ROMS_DIRS=(
  "/run/media/deck/EmuDeck/Emulation/roms"
  "/home/deck/Emulation/roms"
)

ROM_EXTENSIONS=(
  "*.7z" "*.zip" "*.chd" "*.iso" "*.bin" "*.cue"
  "*.nsp" "*.xci" "*.nca"
  "*.gba" "*.gbc" "*.gb" "*.nds" "*.3ds" "*.cia"
  "*.nes" "*.sfc" "*.smc" "*.n64" "*.z64" "*.v64"
  "*.gcm" "*.rvz" "*.wbfs" "*.wad" "*.dol"
  "*.pbp" "*.cso"
  "*.xex" "*.xbe"
  "*.gen" "*.sms" "*.gg"
  "*.a26" "*.a52" "*.a78"
  "*.lnx"
  "*.pce"
  "*.ngp" "*.ngc"
  "*.ws" "*.wsc"
  "*.vec"
)

SEARCH_PATHS=(
  "/home/deck"
  "/run/media/deck"
  "/tmp"
)

PRUNE_DIRS=(
  "/home/deck/.local/share/Steam/steamapps"
  "/home/deck/.local/share/Steam/ubuntu12_32"
  "/home/deck/.local/share/Steam/ubuntu12_64"
  "/home/deck/.local/share/Steam/package"
  "/home/deck/.local/share/flatpak"
  "/home/deck/.var"
  "/home/deck/.cache"
  "/home/deck/.config"
  "/home/deck/.local/share/Trash"
  "/home/deck/.local/share/baloo"
  "/home/deck/.local/lib"
  "/home/deck/.cargo"
  "/home/deck/.rustup"
  "/home/deck/.npm"
  "/home/deck/.nvm"
  "/home/deck/homebrew"
)

# Skip common non-ROM directories (node_modules, .git, etc.)
PRUNE_NAMES=(
  "node_modules"
  ".git"
  "__pycache__"
  ".venv"
  "venv"
)

# Build the find command
FIND_ARGS=()

# Add prune rules for known roms dirs and system dirs
for dir in "${KNOWN_ROMS_DIRS[@]}" "${PRUNE_DIRS[@]}"; do
  FIND_ARGS+=( -path "$dir" -prune -o )
done

# Add prune rules by directory name
for name in "${PRUNE_NAMES[@]}"; do
  FIND_ARGS+=( -name "$name" -prune -o )
done

# Add extension matches
FIND_ARGS+=( \( )
first=true
for ext in "${ROM_EXTENSIONS[@]}"; do
  if $first; then
    first=false
  else
    FIND_ARGS+=( -o )
  fi
  FIND_ARGS+=( -iname "$ext" )
done
FIND_ARGS+=( \) -type f -print )

echo "Searching for ROM files outside of standard roms directories..."
echo "Known roms paths (excluded from results):"
for dir in "${KNOWN_ROMS_DIRS[@]}"; do
  echo "  $dir"
done
echo ""

found=0
while IFS= read -r file; do
  if (( found == 0 )); then
    echo "=== Possible lost ROMs ==="
  fi
  size=$(du -h "$file" 2>/dev/null | cut -f1)
  echo "  [$size]  $file"
  ((found++))
done < <(find "${SEARCH_PATHS[@]}" "${FIND_ARGS[@]}" 2>/dev/null)

if (( found == 0 )); then
  echo "No ROM files found outside of standard roms directories."
else
  echo ""
  echo "Found $found file(s)."
fi

read -p "Press Enter to close..."
