#!/usr/bin/env bash
# Generate a single-track MODE2/2352 .cue file for each .bin file if missing

shopt -s nullglob

for f in *.bin; do
  cue="${f%.bin}.cue"

  if [ ! -e "$cue" ]; then
    echo -e "FILE \"$f\" BINARY\n  TRACK 01 MODE2/2352\n    INDEX 01 00:00:00" > "$cue"
  fi
done
