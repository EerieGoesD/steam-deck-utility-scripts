#!/bin/bash
rm -rf /run/media/deck/EmuDeck/Emulation/tools/downloaded_media/
find ~/.config/EmuDeck/backend/configs/emulationstation/gamelists/ -name "gamelist.xml" -delete
find ~/ES-DE/gamelists/ -name "gamelist.xml" -delete
echo "Done. Media and metadata cleared."
read -p "Press Enter to close..."
