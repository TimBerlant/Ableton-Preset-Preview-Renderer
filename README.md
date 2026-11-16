# Rack Preview Renderer for Ableton Live

Rack Preview Renderer creates stereo 24-bit WAV previews next to instrument presets on macOS. It runs inside Ableton Live 12 with Max for Live, using a single MIDI note or a custom MIDI file as input.

Version 0.2.11 accepts instrument presets in `.adg`, `.adv`, `.aupreset`, `.vstpreset` and `.fxp` formats. Live must expose the preset under Places or the User Library, and the corresponding plug-in must be installed and enabled. AU and VST rendering still needs end-to-end verification.

## Install

1. Quit Live. Unzip the release archive and run **Install.command** for the default User Library location. Use **Update.command** for an existing installation.
2. For a custom User Library location, copy **RackPreviewLoader** from **Remote Scripts** into your User Library’s **Remote Scripts** folder.
3. For a manual installation, also copy the entire **Device** folder into your User Library. Keep the `.amxd` and its companion JavaScript files together. The `.maxpat` is editable patch source.
4. Open Live. In **Settings → Link, Tempo & MIDI**, select **RackPreviewLoader** in one **Control Surface** slot. Leave its Input and Output at **None**.
5. Start a blank Live Set. Create a clean MIDI track and drop **Rack Preview Renderer.amxd** onto it as its only device. Leave an empty Session slot and the audio engine on.

## Render and verify

1. In the active User Library, create a folder such as **Preview Test**. Put two known audible Instrument Rack presets in it, including their sample dependencies if applicable. You can also use an external folder. Add it or a parent folder under **Places → Add Folder** in Live and wait for the racks to appear in the browser. The batch reads the selected folder directly.
2. Set MIDI note, velocity, note length, tail, normalization and WAV overwrite in the device. Defaults are MIDI note 60, velocity 100, one second each for note and tail, normalization on and overwrite off. The batch uses a snapshot of the controls at startup.
3. Click **No Folder** under **Folder**, select **Preview Test**, then click **Start** when ready. Click **Start** again to rerun the same folder. Leave the Set, device chain and tempo alone until the count appears.
4. Play both WAVs and confirm they match their racks, play one note each, include the release and have roughly the expected duration. Leading silence is trimmed automatically, leaving up to 2 ms before the detected onset. The trailing audio is preserved.
5. Run again with overwrite off to verify existing WAVs are skipped. Turn on overwrite to render them again. Existing files are replaced after successful capture and conversion. Normalization uses one gain across both channels to reach 0 dBFS sample peak. With normalization off, samples above full scale clip during 24-bit conversion.

The device stops and resets Live's transport as it works and leaves the last rack on the track. If you restart Live or reselect the control surface, remove that rack before restarting the batch. Use a scratch Set. For failures, open the Max Console to see per-rack messages. If a rack is missing from the browser, confirm Live has indexed it under User Library. If it renders silence, try a note in its playable range and check for missing samples or plug-ins.

## Source and verification

Based on [AbletonPreviewRenderer](https://github.com/mgarbvs/AbletonPreviewRenderer/tree/6abd901eb0cadb34dbb03fdf41c413c0a8e0a5af), MIT license included. Reuses the audio-effect patch structure, browser traversal and loading approach, file request polling, and single-note clip capture pattern. The pack registration and OGG workflow are omitted.

The project was checked outside Live. The smoke test above is the acceptance test for Live 12.4.3.

## Update v0.2.1

The version is shown in the device and printed before and after installation. After updating, replace any older instance in your Set and check the version in the top-right corner.

### Drag in a ready-to-use MIDI track

Live creates an audio track when you drop the standalone renderer into empty space because it is a Max Audio Effect. The effect captures the signal after the Instrument Rack.

For a reusable drag-in setup, create an empty MIDI track with the renderer as its only device. Drag the **track header** into the User Library to save it as a Live Set. Name it **Rack Preview MIDI Track**. In Live’s browser, expand that saved Set and drag its MIDI track into the empty track area. Save the template before starting a batch so it contains no loaded rack.

## Update v0.2.2

**Cut Silence** trims the end of each preview when enabled. The detector uses −60 dB relative to the recording peak, with 20 ms retained after the last frame above threshold. Leading silence is trimmed in either mode. Pauses inside a preview are preserved. Enable **Overwrite Existing Previews** to apply the option to previously rendered WAVs.

## Update v0.2.3

Velocity, Note Length and Tail sit together as dials. After selection, the folder button displays the folder name and remains clickable. Start begins the batch.

## Update v0.2.4

Cut Silence is on by default. The selected folder appears on the picker button. Note Length and Tail align with Start and Abort.

## Update v0.2.5

The Folder field shows No Folder until you select a folder, then displays its name. Click the field to choose a different folder. Start runs the batch. The Abort button has been removed.

## Update v0.2.6

Use **Single Rack → No Rack** to choose one .adg. Click **Start** to render just that rack. Choosing a rack clears Folder, and choosing a folder clears Single Rack. The WAV is saved beside the source rack using the same settings as folder mode. External racks must be visible under Places.

## Update v0.2.7

Folder and Single Rack use matching selector fields with separate labels and arrows.

## Update v0.2.8

Click **Single Note** under **MIDI File** to choose a .mid or .midi file. Start plays the file’s pitches, note lengths and velocities through each selected rack at the Live Set tempo, then records the configured Tail. File tempo changes and controller data are ignored. Click **×** to return to the device’s single-note settings. Supports beat-based MIDI formats 0 and 1 and phrases up to 120 seconds at the Set tempo.

## Update v0.2.9

Folder and Single Rack show Not selected until chosen. The bottom panel reserves room for errors and the version sits to its right.

## Update v0.2.10

Click **Cancel** beside **Start** to stop the current render and skip the rest of the batch. WAVs already saved are kept. A rack load already in progress can finish before cancellation completes.

## Update v0.2.11

Folder and Single Preset accept .adg, .adv, .aupreset, .vstpreset and .fxp. The preset must be loadable from the Live browser through Places or the User Library, and the matching plug-in must be installed and enabled. Files visible only in a plug-in’s own preset manager require a separate loading workflow. Only instrument presets can render from MIDI. VST2 banks (.fxb) contain multiple programs and are outside this single-preset workflow. Mixed folders with duplicate WAV names require selecting one preset at a time.
