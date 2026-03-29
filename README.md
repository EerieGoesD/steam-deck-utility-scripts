# Steam Deck Utility Scripts
Personal collection of useful scripts for the Steam Deck.

## Scripts

### PS1 Emulation

- **`bin-to-cue.sh`**
  - Generates a single-track MODE2/2352 `.cue` file for each `.bin` in the current directory.
  - Run it from the same folder as your `.bin` files.

### Maintenance

- **`maintenance.sh`**
  - Weekly maintenance script.
  - Updates and removes unused Flatpak runtimes.
  - Vacuums and rotates system/user journals.
  - Trims mounted filesystems.
  - Cleans temp files and thumbnail cache.
  - Checks SMART disk health.
  - Logs everything to `~/.local/state/steamdeck-maintenance/logs/`.
  - Skips heavy tasks if on battery, in Gaming Mode, or offline.

### Fixes

- **`gamescope-reset.sh`**
  - Clears Gamescope user state/config.
  - Reboot recommended after running.

- **`steam-reset.sh`**
  - Renames `~/.local/share/Steam` to `Steam_backup`.
  - Forces Steam to reinitialize on next launch.
  - You will need to sign back into Steam afterwards.

- **`steamdeck-recovery.sh`**
  - Same as these scripts together:
    - `gamescope-reset.sh`
    - `steam-reset.sh`
  - Reboot recommended after running.

### ROM Management
- **`duplicate-rom-finder.sh`**
  - Finds duplicate ROM files across all console folders.
  - Shows each duplicate's name and location.
  - Useful for freeing up SD card space.

- **`find_lost_roms.sh`**
  - Searches for ROM files that ended up outside the standard EmuDeck roms directories.
  - Scans `/home/deck` and `/run/media/deck` while skipping known roms paths and system folders.
  - Shows file size and full path for each result.
  - Covers a wide range of ROM extensions (`.chd`, `.iso`, `.nsp`, `.gba`, `.nes`, etc.).

### Cleanup
- **`find_decky_leftovers.sh`**
  - Searches for leftover Decky Loader files after uninstall.
  - Checks known Decky paths (`~/homebrew`, systemd services, configs).
  - Also searches by name for anything with "decky" or "plugin_loader" in it.

- **`cleanup_decky.sh`**
  - Removes leftover Decky Loader files (`~/homebrew`, old systemd services).
  - Shows everything that will be deleted with sizes before asking for confirmation.

### Uninstallers
- **`uninstall_decky.sh`**
  - Uninstalls Decky Loader using the official SteamDeckHomebrew uninstall script.

## Desktop Shortcuts
The `desktop/` folder contains `.desktop` files you can copy to `~/Desktop/` for quick double-click access. Right-click and "Mark as Trusted" after copying.

## Feedback
Created by **[EERIE](https://linktr.ee/eeriegoesd)**  
Support: https://buymeacoffee.com/eeriegoesd
