#!/bin/bash
set -eu
cd "$(dirname "$0")"
library="$HOME/Music/Ableton/User Library"
if [[ ! -d "$library" ]]; then
    printf 'Ableton User Library was not found at %s\n' "$library"
    exit 1
fi
device="$library/Rack Preview Renderer"
loader="$library/Remote Scripts/RackPreviewLoader"
if [[ -e "$device" || -e "$loader" ]]; then
    printf 'Rack Preview Renderer is already installed. Run Update.command to update it.\n'
    exit 1
fi
/usr/bin/ditto Device "$device"
/usr/bin/ditto 'Remote Scripts/RackPreviewLoader' "$loader"
printf 'Installed. In Live, select RackPreviewLoader as a Control Surface under Settings → Link, Tempo & MIDI.\n'
