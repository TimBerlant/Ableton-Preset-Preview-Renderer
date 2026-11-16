#!/bin/bash
set -eu
cd "$(dirname "$0")"
library="$HOME/Music/Ableton/User Library"
device="$library/Rack Preview Renderer"
loader="$library/Remote Scripts/RackPreviewLoader"
if [[ ! -d "$device" || ! -d "$loader" ]]; then
    printf 'Existing installation not found. Run Install.command first.\n'
    exit 1
fi
printf 'Updating Rack Preview Renderer to v0.2.11\n'

backup=$(mktemp -d "${TMPDIR:-/tmp}/RackPreviewBackup.XXXXXX")
/usr/bin/ditto "$device" "$backup/Device"
/usr/bin/ditto "$loader" "$backup/RackPreviewLoader"
/usr/bin/ditto Device "$device"
/usr/bin/ditto 'Remote Scripts/RackPreviewLoader' "$loader"
cmp -s "Device/Rack Preview Renderer.amxd" "$device/Rack Preview Renderer.amxd"
printf 'Installed v0.2.11 at %s\n' "$device/Rack Preview Renderer.amxd"
for previous in "${TMPDIR:-/tmp}"/RackPreviewBackup.*; do
    [[ -d "$previous/Device" && -d "$previous/RackPreviewLoader" && "$previous" -ef "$backup" ]] && continue
    if [[ -f "$previous/Device/Rack Preview Renderer.amxd" && -f "$previous/RackPreviewLoader/__init__.py" && ! -L "$previous" ]]; then
        /bin/rm -r -- "$previous"
    fi
done
printf 'Updated. Latest backup saved to %s\n' "$backup"
