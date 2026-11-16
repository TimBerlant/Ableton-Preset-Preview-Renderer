// Folder conversion and request polling adapted from upstream pack_node.js.
"use strict";
const fs = require("fs");
const os = require("os");
const path = require("path");
const {execFile} = require("child_process");
const {randomUUID} = require("crypto");
const max = require("max-api");
const {parseMidi} = require("./midi");
const {convertWav} = require("./wav");

const ipc = path.join(os.homedir(), "Library", "Caches", "RackPreviewRenderer");
const request = path.join(ipc, "request.json");
const response = path.join(ipc, "response.json");
const sleep = ms => new Promise(resolve => setTimeout(resolve, ms));
const controls = {note: 60, velocity: 100, noteSeconds: 1, tailSeconds: 1,
    normalize: true, overwrite: false, cutSilence: true};
const presetExtension = /\.(adg|adv|aupreset|vstpreset|fxp)$/i;
let selectedPath;
let midiPath;
let running = false;
let cancelled = false;
let reply;

function status(message) {
    max.outlet(1, "set", message);
    max.post(message);
}

for (const key of ["note", "velocity", "noteSeconds", "tailSeconds"]) {
    max.addHandler(key, value => { controls[key] = value; });
}
for (const key of ["normalize", "overwrite", "cutSilence"]) {
    max.addHandler(key, value => { controls[key] = value === 1; });
}

async function waitFor(read, ms, message, canCancel = true) {
    const deadline = Date.now() + ms;
    while (Date.now() < deadline) {
        if (cancelled && canCancel) throw new Error("Canceled.");
        const result = read();
        if (result !== undefined) return result;
        await sleep(50);
    }
    throw new Error(message);
}

async function load(track, preset) {
    const id = randomUUID();
    const temp = path.join(ipc, id + ".json");
    fs.writeFileSync(temp, JSON.stringify({id, track, preset}));
    let published = false;
    let acknowledged = false;
    try {
        fs.linkSync(temp, request);
        published = true;
        const result = await waitFor(() => {
            if (!fs.existsSync(response)) return;
            const data = JSON.parse(fs.readFileSync(response, "utf8"));
            if (data.id === id) return data;
        }, 12000, "Loader timeout. Enable RackPreviewLoader in Live Settings.", false);
        acknowledged = true;
        if (result.error) throw new Error(result.error);
    } finally {
        fs.unlinkSync(temp);
        if (published && !acknowledged) fs.rmSync(request, {force: true});
    }
}

let choosing = false;
max.addHandler("choose_folder", () => chooseSource(false));
max.addHandler("choose_rack", () => chooseSource(true));

function chooseSource(singleRack) {
    if (running || choosing) return;
    choosing = true;
    status(singleRack ? "Opening rack picker…" : "Opening folder picker…");
    const dialog = singleRack ?
        'choose file with prompt "Choose an instrument preset"' :
        'choose folder with prompt "Choose the folder containing your instrument racks"';
    execFile("/usr/bin/osascript", ["-e", "activate", "-e", "POSIX path of (" + dialog + ")"],
        (error, stdout) => {
            choosing = false;
            if (error) {
                status(error.message.includes("(-128)") ?
                    (selectedPath ? "Selection canceled. Previous selection kept." : "Selection canceled.") :
                    "Picker failed: " + error.message);
                return;
            }
            const selection = stdout.replace(/\r?\n$/, "");
            if (singleRack && !presetExtension.test(selection)) {
                status("Choose an instrument preset.");
                return;
            }
            selectedPath = selection;
            const name = path.basename(path.resolve(selection)) || selection;
            const characters = Array.from(name);
            const label = characters.length > 17 ? characters.slice(0, 16).join("") + "…" : name;
            max.outlet(1, "folder_label", ...(singleRack ? "Not selected" : label).split(/\s+/));
            max.outlet(1, "rack_label", ...(singleRack ? label : "Not selected").split(/\s+/));
            status("Ready. Click Start to render.");
        });
}
max.addHandler("choose_midi", () => {
    if (running || choosing) return;
    choosing = true;
    execFile("/usr/bin/osascript", ["-e", "activate", "-e",
        'POSIX path of (choose file with prompt "Choose a MIDI preview file")'
    ], (error, stdout) => {
        choosing = false;
        if (error) {
            if (!error.message.includes("(-128)")) status(error.message);
            return;
        }
        const selection = stdout.replace(/\r?\n$/, "");
        if (!/\.midi?$/i.test(selection)) return status("Choose a .mid or .midi file.");
        midiPath = selection;
        const name = Array.from(path.basename(selection));
        max.outlet(1, "midi_label", ...(name.length > 12 ? name.slice(0, 11).join("") + "…" : name.join("")).split(/\s+/));
        status("MIDI: " + path.basename(selection));
    });
});
max.addHandler("clear_midi", () => {
    if (running || choosing) return;
    midiPath = undefined;
    max.outlet(1, "midi_label", "Single", "Note");
    status("Single-note mode.");
});
max.addHandler("prepared", (track, tempo) => { reply = {track, tempo}; });
max.addHandler("captured", () => { reply = {}; });
max.addHandler("failed", (...atoms) => { reply = {error: atoms.join(" ")}; });
max.addHandler("abort", () => {
    if (running) {
        cancelled = true;
        max.outlet(0, "cancel");
        status("Canceling…");
    }
});

max.addHandler("batch", batch);

async function batch() {
    if (running || choosing) return;
    if (!selectedPath) return status("Choose a folder or single preset first.");
    running = true;
    cancelled = false;
    let scratch;
    try {
        const selection = fs.realpathSync(selectedPath);
        const entry = fs.statSync(selection);
        if (!entry.isDirectory() && !(entry.isFile() && presetExtension.test(selection))) {
            throw new Error("Choose a folder or a supported instrument preset.");
        }
        const directory = entry.isDirectory() ? selection : path.dirname(selection);
        const config = {...controls};
        const midi = midiPath ? parseMidi(fs.readFileSync(midiPath)) : null;
        const midiNotes = midi ? JSON.stringify(midi.notes) : "";
        if (midiNotes.length > 20000) throw new Error("Choose a shorter MIDI file.");

        const pitchClasses = ["C", "C#", "D", "D#", "E", "F", "F#", "G", "G#", "A", "A#", "B"];
        const noteName = pitchClasses[config.note % 12] + (Math.floor(config.note / 12) - 2);
        const summary = midi ? "MIDI: " + path.basename(midiPath) : noteName + " · Velocity " + config.velocity +
            " · " + config.noteSeconds.toFixed(2) + " s note · " +
            config.tailSeconds.toFixed(2) + " s tail";
        const report = message => status(message + "\n" + summary);
        const racks = entry.isFile() ? [path.basename(selection)] : fs.readdirSync(directory, {withFileTypes: true})
            .filter(entry => entry.isFile() && presetExtension.test(entry.name))
            .map(entry => entry.name).sort();
        if (!racks.length) throw new Error("No supported preset files in the selected folder.");
        const names = new Set();
        for (const preset of racks) {
            const stem = path.parse(preset).name.normalize("NFC").toLowerCase();
            if (names.has(stem)) {
                throw new Error("Presets share a WAV name. Select one preset at a time: " + preset);
            }
            names.add(stem);
        }

        reply = undefined;
        max.outlet(0, "prepare");
        const prepared = await waitFor(() => reply, 3000, "Renderer did not respond.");
        if (prepared.error) throw new Error(prepared.error);
        const duration = midi ? midi.beats * 60 / prepared.tempo : config.noteSeconds;
        if (!Number.isFinite(duration) || duration > 120) {
            throw new Error("Choose a MIDI phrase no longer than 120 seconds at the Set tempo.");
        }

        fs.mkdirSync(ipc, {recursive: true});
        scratch = fs.mkdtempSync(path.join(ipc, "batch-"));
        let saved = 0;
        let skipped = 0;
        let failed = 0;
        let lastError = "";
        for (const rack of racks) {
            if (cancelled) throw new Error("Canceled.");
            const destination = path.join(directory, path.parse(rack).name + ".wav");
            if (!config.overwrite && fs.existsSync(destination)) {
                skipped++;
                continue;
            }
            const capture = path.join(scratch, "capture.wav");
            try {
                report("Loading " + rack);
                await load(prepared.track, path.join(directory, rack));
                await sleep(1000);
                if (cancelled) throw new Error("Canceled.");
                reply = undefined;
                report("Recording " + rack);
                max.outlet(0, "capture", capture, config.note, config.velocity,
                    duration, config.tailSeconds, ...(midi ? [midiNotes] : []));
                const result = await waitFor(() => reply,
                    (duration + config.tailSeconds + 5) * 1000, "Capture timeout");
                if (result.error) throw new Error(result.error);
                await sleep(250);
                if (cancelled) throw new Error("Canceled.");
                const wav = convertWav(fs.readFileSync(capture), config.normalize, config.cutSilence);
                if (wav.seconds < duration + config.tailSeconds - 0.05) {
                    throw new Error("Recording ended early. Check Live’s audio engine.");
                }
                if (wav.peak === 0) throw new Error("Silent recording. Check the note and rack.");
                const staged = path.join(directory, ".preview-" + randomUUID() + ".wav");
                try {
                    fs.writeFileSync(staged, wav.output, {flag: "wx"});
                    if (config.overwrite) fs.renameSync(staged, destination);
                    else fs.linkSync(staged, destination);
                } finally {
                    fs.rmSync(staged, {force: true});
                }
                saved++;
            } catch (error) {
                max.outlet(0, "cancel");
                if (cancelled || /timeout/i.test(error.message)) throw error;
                failed++;
                lastError = rack + " — " + error.message;
                status(lastError);
            } finally {
                fs.rmSync(capture, {force: true});
            }
        }
        const result = "Saved " + saved + " · skipped " + skipped + " · failed " + failed +
            (lastError ? "\n" + lastError : "");
        if (lastError) status(result);
        else report(result);
    } catch (error) {
        status(error.message);
    } finally {
        if (scratch) fs.rmdirSync(scratch);
        running = false;
    }
}
