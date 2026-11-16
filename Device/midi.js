// SMF event parsing adapted from AbletonPreviewRenderer (MIT).
"use strict";

function parseMidi(buffer) {
    if (buffer.length < 14 || buffer.toString("ascii", 0, 4) !== "MThd") {
        throw new Error("Invalid MIDI header.");
    }
    const format = buffer.readUInt16BE(8);
    const tracks = buffer.readUInt16BE(10);
    const ppq = buffer.readUInt16BE(12);
    let pos = 8 + buffer.readUInt32BE(4);
    if (format > 1 || !tracks || !ppq || ppq >= 0x8000 || pos < 14) {
        throw new Error("Choose a MIDI format 0 or 1 file with beat-based timing.");
    }
    const notes = [];
    for (let track = 0; track < tracks; track++) {
        if (pos + 8 > buffer.length || buffer.toString("ascii", pos, pos + 4) !== "MTrk") {
            throw new Error("Missing MIDI track.");
        }
        const end = pos + 8 + buffer.readUInt32BE(pos + 4);
        pos += 8;
        if (end > buffer.length) throw new Error("Truncated MIDI track.");
        let tick = 0;
        let status = 0;
        const active = new Map();
        function byte() {
            if (pos >= end) throw new Error("Truncated MIDI event.");
            return buffer[pos++];
        }
        function vlq() {
            let value = 0;
            for (let i = 0; i < 4; i++) {
                const b = byte();
                value = value * 128 + (b & 127);
                if (b < 128) return value;
            }
            throw new Error("Invalid MIDI event length.");
        }
        while (pos < end) {
            tick += vlq();
            if (buffer[pos] >= 128) status = byte();
            if (status === 255 || status === 240 || status === 247) {
                const meta = status === 255 ? byte() : -1;
                const length = vlq();
                pos += length;
                if (pos > end) throw new Error("Truncated MIDI event.");
                status = 0;
                if (meta === 47) break;
                continue;
            }
            if (status < 128 || status >= 240) throw new Error("Invalid MIDI status.");
            const type = status & 240;
            const pitch = byte();
            const velocity = type === 192 || type === 208 ? 0 : byte();
            if (pitch > 127 || velocity > 127) throw new Error("Invalid MIDI data.");
            if (type !== 128 && type !== 144) continue;
            const key = (status & 15) * 128 + pitch;
            const pending = active.get(key) || [];
            if (type === 144 && velocity) {
                pending.push({tick, velocity});
                active.set(key, pending);
            } else if (pending.length) {
                const start = pending.shift();
                if (tick > start.tick) notes.push({
                    pitch, start_time: start.tick / ppq, duration: (tick - start.tick) / ppq,
                    velocity: start.velocity
                });
            }
        }
        pos = end;
    }
    if (!notes.length) throw new Error("The MIDI file contains no complete notes.");
    const beats = notes.reduce((end, note) => Math.max(end, note.start_time + note.duration), 0);
    return {notes, beats};
}

module.exports = {parseMidi};
