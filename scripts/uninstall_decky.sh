#!/bin/bash
# Uninstalls Decky Loader using the official uninstall script from SteamDeckHomebrew.
# https://github.com/SteamDeckHomebrew/decky-loader

curl -L https://github.com/SteamDeckHomebrew/decky-installer/releases/latest/download/uninstall.sh | sh

read -p "Press Enter to close..."
