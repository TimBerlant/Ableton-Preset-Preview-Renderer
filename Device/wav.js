"use strict";

// Read Max's stereo float WAV (including WAVE_FORMAT_EXTENSIBLE).
function convertWav(source, normalize, cutSilence = false) {
    if (source.toString("ascii", 0, 4) !== "RIFF" ||
        source.toString("ascii", 8, 12) !== "WAVE") {
        throw new Error("Recorder did not produce a RIFF WAV");
    }
    let format;
    let samples;
    for (let offset = 12; offset + 8 <= source.length;) {
        const name = source.toString("ascii", offset, offset + 4);
        const size = source.readUInt32LE(offset + 4);
        const start = offset + 8;
        if (start + size > source.length) throw new Error("Incomplete WAV");
        if (name === "fmt ") format = source.subarray(start, start + size);
        if (name === "data") samples = source.subarray(start, start + size);
        offset = start + size + (size & 1);
    }
    if (!format || format.length < 16 || !samples || !samples.length || samples.length % 8) {
        throw new Error("Missing or invalid WAV audio");
    }
    const tag = format.readUInt16LE(0);
    const float = tag === 3 || (tag === 65534 && format.length >= 40 &&
        format.subarray(24, 40).toString("hex") === "0300000000001000800000aa00389b71");
    const rate = format.readUInt32LE(4);
    if (!float || format.readUInt16LE(2) !== 2 || format.readUInt16LE(14) !== 32 || !rate) {
        throw new Error("Expected stereo 32-bit float capture");
    }
    let peak = 0;
    for (let offset = 0; offset < samples.length; offset += 4) {
        const sample = samples.readFloatLE(offset);
        if (!Number.isFinite(sample)) throw new Error("Non-finite WAV sample");
        peak = Math.max(peak, Math.abs(sample));
    }
    const gain = normalize && peak > 0 ? 1 / peak : 1;
    // Detect the onset relative to the capture peak and retain a short lead-in.
    let onset = 0;
    const threshold = peak * 0.001;
    while (onset < samples.length &&
        Math.abs(samples.readFloatLE(onset)) < threshold &&
        Math.abs(samples.readFloatLE(onset + 4)) < threshold) onset += 8;
    const start = Math.max(0, onset - Math.ceil(rate * 0.002) * 8);
    let end = samples.length;
    if (cutSilence && peak > 0) {
        while (end > start &&
            Math.abs(samples.readFloatLE(end - 8)) < threshold &&
            Math.abs(samples.readFloatLE(end - 4)) < threshold) end -= 8;
        end = Math.min(samples.length, end + Math.ceil(rate * 0.02) * 8);
    }
    const bytes = (end - start) / 4 * 3;
    const output = Buffer.alloc(44 + bytes);
    output.write("RIFF");
    output.writeUInt32LE(output.length - 8, 4);
    output.write("WAVEfmt ", 8);
    output.writeUInt32LE(16, 16);
    output.writeUInt16LE(1, 20);
    output.writeUInt16LE(2, 22);
    output.writeUInt32LE(rate, 24);
    output.writeUInt32LE(rate * 6, 28);
    output.writeUInt16LE(6, 32);
    output.writeUInt16LE(24, 34);
    output.write("data", 36);
    output.writeUInt32LE(bytes, 40);
    for (let input = start, dest = 44; input < end; input += 4, dest += 3) {
        const value = Math.round(samples.readFloatLE(input) * gain * 8388608);
        output.writeIntLE(Math.max(-8388608, Math.min(8388607, value)), dest, 3);
    }
    return {output, peak, seconds: samples.length / 8 / rate};
}

module.exports = {convertWav};
