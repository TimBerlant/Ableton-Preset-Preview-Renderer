[README.md](https://github.com/user-attachments/files/34933948/README.md)
Generate WAV previews for instrument presets in Ableton Live 12 on macOS.

## Quick start

1. Download the installable ZIP from **Releases**, unzip it, quit Live, and run `Install.command`.
2. Open Live. Under **Settings → Link, Tempo & MIDI**, select **RackPreviewLoader** as a **Control Surface**. Leave Input and Output set to **None**.
3. Drop **Rack Preview Renderer.amxd** onto an empty **MIDI track**.
4. Choose a **Folder** or **Single Preset** and click **Start**. The WAV is saved beside the preset.

Instrument presets supported for selection: `.adg`, `.adv`, `.aupreset`, `.vstpreset`, and `.fxp`. Live must be able to load the preset. AU and VST rendering still needs end-to-end testing.

## Contribute

This is an early release. Issues, forks, and pull requests are welcome. The editable Max patch and scripts are included under the MIT license. Based on [AbletonPreviewRenderer](https://github.com/mgarbvs/AbletonPreviewRenderer).
