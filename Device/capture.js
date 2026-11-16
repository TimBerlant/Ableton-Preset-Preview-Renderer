// Adapted from the MIT-licensed AbletonPreviewRenderer render_engine.js.
inlets = 1;
outlets = 2;

var slot = null;
var finish = null;
var launch = null;
var setup = null;
var song = null;

function prepare() {
    var track = new LiveAPI("this_device canonical_parent");
    var match = /^live_set tracks (\d+)$/.exec(track.path.replace(/"/g, ""));
    if (!match || !Number(track.get("has_midi_input"))) {
        outlet(1, "failed", "Place the renderer on a MIDI track.");
        return;
    }
    outlet(1, "prepared", Number(match[1]), Number(new LiveAPI("live_set").get("tempo")));
}

function capture(file, pitch, velocity, length, tail, midiNotes) {
    try {
        song = new LiveAPI("live_set");
        var track = new LiveAPI("this_device canonical_parent");
        if (track.getcount("devices") !== 2 ||
            Number(new LiveAPI("this_device canonical_parent devices 0").get("type")) !== 1) {
            throw new Error("This preset must load an instrument before the recorder.");
        }
        var slotPath;
        var count = track.getcount("clip_slots");
        for (var index = 0; index < count; index++) {
            var candidatePath = "this_device canonical_parent clip_slots " + index;
            var candidate = new LiveAPI(candidatePath);
            if (!Number(candidate.get("has_clip"))) {
                slot = candidate;
                slotPath = candidatePath;
                break;
            }
        }
        if (!slot) throw new Error("Leave an empty Session View clip slot");
        var beatsPerSecond = Number(song.get("tempo")) / 60;
        var noteBeats = length * beatsPerSecond;
        song.call("stop_playing");
        song.set("current_song_time", 0);
        slot.call("create_clip", Math.max(1, (length + tail + 1) * beatsPerSecond));
        var attempts = 0;
        setup = new Task(function () {
            try {
                var clip = new LiveAPI(slotPath + " clip");
                if (!Number(clip.id)) {
                    if (++attempts >= 20) throw new Error("Live did not expose the temporary MIDI clip.");
                    setup.schedule(50);
                    return;
                }
                clip.call("add_new_notes", JSON.stringify({notes: midiNotes ? JSON.parse(midiNotes) : [{
                    pitch: pitch, start_time: 0, duration: noteBeats, velocity: velocity
                }]}));
                clip.set("looping", 0);
                clip.set("launch_quantization", 1);

                outlet(0, "samptype", "float32");
                outlet(0, "open", file);
                outlet(0, 1);
                launch = new Task(function () {
                    try {
                        slot.call("fire");
                    } catch (error) {
                        cleanup();
                        outlet(1, "failed", String(error));
                        return;
                    }
                    finish = new Task(function () {
                        cleanup();
                        outlet(1, "captured");
                    }, this);
                    finish.schedule((length + tail) * 1000 + 100);
                }, this);
                launch.schedule(100);
            } catch (error) {
                cleanup();
                outlet(1, "failed", String(error));
            }
        }, this);
        setup.schedule(50);
    } catch (error) {
        cleanup();
        outlet(1, "failed", String(error));
    }
}

function cleanup() {
    if (setup) setup.cancel();
    if (launch) launch.cancel();
    if (finish) finish.cancel();
    outlet(0, 0);
    if (slot) {
        if (Number(slot.get("has_clip"))) {
            slot.call("stop");
            slot.call("delete_clip");
        }
        slot = null;
    }
    if (song) {
        song.call("stop_playing");
        song = null;
    }
}

function cancel() {
    cleanup();
}

// route 0 strips Node for Max's outlet index and can leave a list.
function list() {
    var args = arrayfromargs(arguments);
    var command = args.shift();
    if (command === "prepare") prepare();
    if (command === "capture") capture.apply(this, args);
    if (command === "cancel") cancel();
}
