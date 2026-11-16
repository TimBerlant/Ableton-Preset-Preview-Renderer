"""Adapted from Michael Garbus's MIT-licensed PreviewLoader."""
import json
import os
from pathlib import Path
import unicodedata
import xml.etree.ElementTree as ET

import Live

IPC = Path.home() / "Library" / "Caches" / "RackPreviewRenderer"


def create_instance(c_instance):
    return PreviewLoader(c_instance)


def navigate(node, parts):
    """Follow the exact User Library path, allowing Live's hidden extension."""
    for index, part in enumerate(parts):
        last = index == len(parts) - 1
        names = {part, Path(part).stem} if last else {part}
        matches = [
            child for child in node.children
            if unicodedata.normalize("NFC", child.name or "") in names
            and (child.is_loadable if last else child.is_folder)
        ]
        if len(matches) != 1:
            raise ValueError("Browser entry missing or ambiguous: " + part)
        node = matches[0]
    return node


def find_preset(app, preset, config):
    browser = app.browser
    library = ET.parse(config).getroot().find("ContentLibrary")
    if library is None:
        raise ValueError("Live’s Library.cfg has no ContentLibrary")
    roots = []
    for entry in library.findall("./UserLibrary/LibraryProject"):
        parent = entry.find("ProjectPath")
        name = entry.find("ProjectName")
        if parent is not None and name is not None:
            roots.append((Path(parent.get("Value")) / name.get("Value"), browser.user_library))
    for entry in library.findall("./UserFolderInfoList/UserFolderInfo"):
        name = unicodedata.normalize("NFC", entry.get("DisplayName", ""))
        matches = [item for item in browser.user_folders
                   if unicodedata.normalize("NFC", item.name or "") == name]
        if len(matches) == 1:
            roots.append((Path(entry.get("Path")), matches[0]))
    preset = Path(preset).resolve()
    for root, item in sorted(roots, key=lambda pair: len(pair[0].parts), reverse=True):
        try:
            parts = preset.relative_to(root.resolve()).parts
        except ValueError:
            continue
        return navigate(item, [unicodedata.normalize("NFC", part) for part in parts])
    raise ValueError("Add this folder to Live’s Places and wait for indexing")


class PreviewLoader:
    def __init__(self, c_instance):
        self._c_instance = c_instance
        self._pending = None
        self._rack = None

    def disconnect(self):
        pass

    def build_midi_map(self, midi_map_handle):
        pass

    def receive_midi(self, midi_bytes):
        pass

    def refresh_state(self):
        pass

    def connect_script_instances(self, instances):
        pass

    def can_lock_to_devices(self):
        return False

    def update_display(self):
        request = IPC / "request.json"
        if self._pending is None:
            try:
                job = json.loads(request.read_text(encoding="utf-8"))
                request.unlink()
            except FileNotFoundError:
                return
            self._pending = (job, None, None, 0)

        job, track, recorder, ticks = self._pending
        try:
            if track is None:
                track, recorder = self._load(job)
                self._pending = (job, track, recorder, 0)
                return
            devices = tuple(track.devices)
            if len(devices) == 2 and devices[1] == recorder:
                self._rack = devices[0]
                self._reply(job, None)
            elif devices == (recorder,) and ticks < 70:
                self._pending = (job, track, recorder, ticks + 1)
            else:
                raise RuntimeError("Live did not load the preset before the recorder")
        except Exception as error:
            self._reply(job, str(error))

    def _load(self, job):
        song = self._c_instance.song()
        track = song.tracks[job["track"]]
        if not track.has_midi_input:
            raise ValueError("Place the renderer on a MIDI track.")
        devices = tuple(track.devices)
        if len(devices) == 1:
            recorder = devices[0]
        elif len(devices) == 2 and devices[0] == self._rack:
            recorder = devices[1]
        else:
            raise ValueError("Remove the other devices from this MIDI track, then click Start again")
        if recorder.name != "Rack Preview Renderer":
            raise ValueError("The renderer device must be named Rack Preview Renderer")
        app = Live.Application.get_application()
        version = "{}.{}.{}".format(app.get_major_version(), app.get_minor_version(), app.get_bugfix_version())
        prefs = Path.home() / "Library" / "Preferences" / "Ableton"
        config = prefs / ("Live " + version) / "Library.cfg"
        if not config.exists() and version.endswith(".0"):
            config = prefs / ("Live " + version[:-2]) / "Library.cfg"
        item = find_preset(app, job["preset"], config)
        if len(devices) == 2:
            track.delete_device(0)
        song.view.selected_track = track
        app.view.show_view("Detail/DeviceChain")
        app.browser.load_item(item)
        return track, recorder

    def _reply(self, job, error):
        self._pending = None
        tmp = IPC / "response.tmp"
        tmp.write_text(json.dumps({"id": job["id"], "error": error}), encoding="utf-8")
        os.replace(tmp, IPC / "response.json")
