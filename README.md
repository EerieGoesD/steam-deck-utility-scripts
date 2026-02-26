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

## Feedback
Created by **[EERIE](https://linktr.ee/eeriegoesd)**  
Support: https://buymeacoffee.com/eeriegoesd
