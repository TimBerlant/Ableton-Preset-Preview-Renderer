{
  "patcher": {
    "fileversion": 1,
    "appversion": {
      "major": 8,
      "minor": 6,
      "revision": 5,
      "architecture": "x64",
      "modernui": 1
    },
    "classnamespace": "box",
    "rect": [
      0,
      0,
      1000,
      740
    ],
    "bglocked": 0,
    "openinpresentation": 1,
    "default_fontsize": 12.0,
    "default_fontface": 0,
    "default_fontname": "Arial",
    "gridonopen": 1,
    "gridsize": [
      15.0,
      15.0
    ],
    "gridsnaponopen": 1,
    "objectsnaponopen": 1,
    "statusbarvisible": 2,
    "toolbarvisible": 1,
    "lefttoolbarpinned": 0,
    "toptoolbarpinned": 0,
    "righttoolbarpinned": 0,
    "bottomtoolbarpinned": 0,
    "toolbars_unpinned_last_save": 0,
    "tallnewobj": 0,
    "boxanimatetime": 200,
    "enablehscroll": 1,
    "enablevscroll": 1,
    "devicewidth": 560,
    "description": "Batch renders one MIDI note per instrument rack",
    "digest": "BatchPreviewRenderer",
    "tags": "",
    "style": "",
    "subpatcher_template": "",
    "assistshowspatchername": 0,
    "boxes": [
      {
        "box": {
          "id": "obj-1",
          "maxclass": "newobj",
          "numinlets": 1,
          "numoutlets": 1,
          "outlettype": [
            ""
          ],
          "patching_rect": [
            30.0,
            15.0,
            115.0,
            22.0
          ],
          "text": "live.thisdevice"
        }
      },
      {
        "box": {
          "id": "obj-2",
          "maxclass": "newobj",
          "numinlets": 1,
          "numoutlets": 2,
          "outlettype": [
            "signal",
            "signal"
          ],
          "patching_rect": [
            30.0,
            60.0,
            55.0,
            22.0
          ],
          "text": "plugin~"
        }
      },
      {
        "box": {
          "id": "obj-3",
          "maxclass": "newobj",
          "numinlets": 2,
          "numoutlets": 0,
          "patching_rect": [
            30.0,
            420.0,
            62.0,
            22.0
          ],
          "text": "plugout~"
        }
      },
      {
        "box": {
          "id": "obj-5",
          "maxclass": "newobj",
          "numinlets": 2,
          "numoutlets": 0,
          "patching_rect": [
            30.0,
            330.0,
            80.0,
            22.0
          ],
          "text": "sfrecord~ 2"
        }
      },
      {
        "box": {
          "id": "obj-7",
          "maxclass": "newobj",
          "numinlets": 1,
          "numoutlets": 2,
          "outlettype": [
            "",
            ""
          ],
          "patching_rect": [
            350.0,
            200.0,
            250.0,
            22.0
          ],
          "text": "js capture.js"
        }
      },
      {
        "box": {
          "id": "obj-24",
          "maxclass": "newobj",
          "numinlets": 1,
          "numoutlets": 2,
          "outlettype": [
            "",
            ""
          ],
          "patching_rect": [
            600.0,
            200.0,
            150.0,
            22.0
          ],
          "text": "node.script batch.js @autostart 1"
        }
      },
      {
        "box": {
          "id": "obj-300",
          "maxclass": "newobj",
          "numinlets": 1,
          "numoutlets": 3,
          "outlettype": [
            "",
            "",
            ""
          ],
          "patching_rect": [
            600,
            240,
            70,
            22
          ],
          "text": "route 0 1"
        }
      },
      {
        "box": {
          "id": "folder-title",
          "maxclass": "comment",
          "text": "Folder",
          "patching_rect": [
            12,
            3,
            128,
            16
          ],
          "presentation": 1,
          "presentation_rect": [
            12,
            3,
            128,
            16
          ]
        }
      },
      {
        "box": {
          "id": "choose",
          "maxclass": "message",
          "text": "Not selected",
          "patching_rect": [
            12,
            23,
            128,
            20
          ],
          "presentation": 1,
          "presentation_rect": [
            12,
            23,
            128,
            20
          ]
        }
      },
      {
        "box": {
          "id": "rack-title",
          "maxclass": "comment",
          "text": "Single Preset",
          "patching_rect": [
            148,
            3,
            128,
            16
          ],
          "presentation": 1,
          "presentation_rect": [
            148,
            3,
            128,
            16
          ]
        }
      },
      {
        "box": {
          "id": "rack-picker",
          "maxclass": "message",
          "text": "Not selected",
          "patching_rect": [
            148,
            23,
            128,
            20
          ],
          "presentation": 1,
          "presentation_rect": [
            148,
            23,
            128,
            20
          ]
        }
      },
      {
        "box": {
          "id": "rack-click",
          "maxclass": "newobj",
          "text": "t b",
          "patching_rect": [
            320,
            145,
            45,
            22
          ]
        }
      },
      {
        "box": {
          "id": "rack-message",
          "maxclass": "message",
          "text": "choose_rack",
          "patching_rect": [
            320,
            180,
            100,
            22
          ]
        }
      },
      {
        "box": {
          "id": "rack-label",
          "maxclass": "newobj",
          "text": "prepend set",
          "patching_rect": [
            880,
            280,
            90,
            22
          ]
        }
      },
      {
        "box": {
          "id": "midi-title",
          "maxclass": "comment",
          "text": "MIDI File",
          "patching_rect": [
            284,
            3,
            105,
            16
          ],
          "presentation": 1,
          "presentation_rect": [
            284,
            3,
            105,
            16
          ]
        }
      },
      {
        "box": {
          "id": "midi-picker",
          "maxclass": "message",
          "text": "Single Note",
          "patching_rect": [
            284,
            23,
            105,
            20
          ],
          "presentation": 1,
          "presentation_rect": [
            284,
            23,
            105,
            20
          ]
        }
      },
      {
        "box": {
          "id": "midi-clear",
          "maxclass": "message",
          "text": "\u00d7",
          "patching_rect": [
            392,
            23,
            18,
            20
          ],
          "presentation": 1,
          "presentation_rect": [
            392,
            23,
            18,
            20
          ],
          "hint": "Return to single-note mode"
        }
      },
      {
        "box": {
          "id": "midi-choose-message",
          "maxclass": "message",
          "text": "choose_midi",
          "patching_rect": [
            430,
            145,
            90,
            22
          ]
        }
      },
      {
        "box": {
          "id": "midi-clear-message",
          "maxclass": "message",
          "text": "clear_midi",
          "patching_rect": [
            430,
            180,
            90,
            22
          ]
        }
      },
      {
        "box": {
          "id": "midi-label",
          "maxclass": "newobj",
          "text": "prepend set",
          "patching_rect": [
            880,
            317,
            90,
            22
          ]
        }
      },
      {
        "box": {
          "id": "batch",
          "maxclass": "message",
          "text": "Start",
          "patching_rect": [
            424,
            23,
            56,
            20
          ],
          "presentation": 1,
          "presentation_rect": [
            424,
            23,
            56,
            20
          ]
        }
      },
      {
        "box": {
          "id": "cancel",
          "maxclass": "message",
          "text": "Cancel",
          "patching_rect": [
            487,
            23,
            60,
            20
          ],
          "presentation": 1,
          "presentation_rect": [
            487,
            23,
            60,
            20
          ]
        }
      },
      {
        "box": {
          "id": "cancel-message",
          "maxclass": "message",
          "text": "abort",
          "patching_rect": [
            380,
            110,
            60,
            22
          ]
        }
      },
      {
        "box": {
          "id": "start-message",
          "maxclass": "message",
          "text": "batch",
          "patching_rect": [
            310,
            110,
            60,
            22
          ]
        }
      },
      {
        "box": {
          "id": "folder-message",
          "maxclass": "message",
          "text": "choose_folder",
          "patching_rect": [
            200,
            110,
            105,
            22
          ]
        }
      },
      {
        "box": {
          "id": "version",
          "maxclass": "comment",
          "text": "v0.2.11",
          "patching_rect": [
            492,
            149,
            55,
            16
          ],
          "presentation": 1,
          "presentation_rect": [
            492,
            149,
            55,
            16
          ],
          "fontsize": 10,
          "textjustification": 2
        }
      },
      {
        "box": {
          "id": "status",
          "maxclass": "comment",
          "text": "Choose a folder or single preset",
          "patching_rect": [
            12,
            119,
            471,
            46
          ],
          "presentation": 1,
          "presentation_rect": [
            12,
            119,
            471,
            46
          ]
        }
      },
      {
        "box": {
          "id": "status-set",
          "maxclass": "newobj",
          "text": "prepend set",
          "patching_rect": [
            680,
            280,
            80,
            22
          ]
        }
      },
      {
        "box": {
          "id": "status-route",
          "maxclass": "newobj",
          "text": "route set folder_label rack_label midi_label",
          "patching_rect": [
            680,
            250,
            80,
            22
          ]
        }
      },
      {
        "box": {
          "id": "note",
          "maxclass": "number",
          "patching_rect": [
            18,
            64,
            62,
            22
          ],
          "presentation": 1,
          "presentation_rect": [
            18,
            64,
            62,
            22
          ],
          "format": 4,
          "minimum": 0,
          "maximum": 127,
          "triangle": 0
        }
      },
      {
        "box": {
          "id": "note-label",
          "maxclass": "comment",
          "text": "MIDI Note",
          "patching_rect": [
            18,
            45,
            62,
            19
          ],
          "presentation": 1,
          "presentation_rect": [
            18,
            45,
            62,
            19
          ],
          "textjustification": 1,
          "fontsize": 11
        }
      },
      {
        "box": {
          "id": "note-default",
          "maxclass": "newobj",
          "text": "loadmess set 60",
          "patching_rect": [
            200,
            440,
            120,
            22
          ]
        }
      },
      {
        "box": {
          "id": "note-message",
          "maxclass": "newobj",
          "text": "prepend note",
          "patching_rect": [
            400,
            440,
            160,
            22
          ]
        }
      },
      {
        "box": {
          "id": "velocity",
          "maxclass": "live.dial",
          "patching_rect": [
            83,
            45,
            70,
            50
          ],
          "presentation": 1,
          "presentation_rect": [
            83,
            45,
            70,
            50
          ],
          "parameter_enable": 1,
          "showname": 1,
          "shownumber": 1,
          "saved_attribute_attributes": {
            "valueof": {
              "parameter_longname": "Velocity",
              "parameter_shortname": "Velocity",
              "parameter_type": 1,
              "parameter_mmin": 1,
              "parameter_mmax": 127,
              "parameter_initial_enable": 1,
              "parameter_initial": [
                100
              ],
              "parameter_unitstyle": 0
            }
          }
        }
      },
      {
        "box": {
          "id": "velocity-default",
          "maxclass": "newobj",
          "text": "loadmess set 100",
          "patching_rect": [
            200,
            476,
            120,
            22
          ]
        }
      },
      {
        "box": {
          "id": "velocity-message",
          "maxclass": "newobj",
          "text": "prepend velocity",
          "patching_rect": [
            400,
            476,
            160,
            22
          ]
        }
      },
      {
        "box": {
          "id": "noteSeconds",
          "maxclass": "live.dial",
          "patching_rect": [
            157,
            45,
            70,
            50
          ],
          "presentation": 1,
          "presentation_rect": [
            157,
            45,
            70,
            50
          ],
          "parameter_enable": 1,
          "showname": 1,
          "shownumber": 1,
          "saved_attribute_attributes": {
            "valueof": {
              "parameter_longname": "Note Length",
              "parameter_shortname": "Note Length",
              "parameter_type": 0,
              "parameter_mmin": 0.05,
              "parameter_mmax": 30,
              "parameter_initial_enable": 1,
              "parameter_initial": [
                1.0
              ],
              "parameter_unitstyle": 9,
              "parameter_units": "%.2f s"
            }
          }
        }
      },
      {
        "box": {
          "id": "noteSeconds-default",
          "maxclass": "newobj",
          "text": "loadmess set 1.0",
          "patching_rect": [
            200,
            512,
            120,
            22
          ]
        }
      },
      {
        "box": {
          "id": "noteSeconds-message",
          "maxclass": "newobj",
          "text": "prepend noteSeconds",
          "patching_rect": [
            400,
            512,
            160,
            22
          ]
        }
      },
      {
        "box": {
          "id": "tailSeconds",
          "maxclass": "live.dial",
          "patching_rect": [
            231,
            45,
            70,
            50
          ],
          "presentation": 1,
          "presentation_rect": [
            231,
            45,
            70,
            50
          ],
          "parameter_enable": 1,
          "showname": 1,
          "shownumber": 1,
          "saved_attribute_attributes": {
            "valueof": {
              "parameter_longname": "Tail",
              "parameter_shortname": "Tail",
              "parameter_type": 0,
              "parameter_mmin": 0,
              "parameter_mmax": 30,
              "parameter_initial_enable": 1,
              "parameter_initial": [
                1.0
              ],
              "parameter_unitstyle": 9,
              "parameter_units": "%.2f s"
            }
          }
        }
      },
      {
        "box": {
          "id": "tailSeconds-default",
          "maxclass": "newobj",
          "text": "loadmess set 1.0",
          "patching_rect": [
            200,
            548,
            120,
            22
          ]
        }
      },
      {
        "box": {
          "id": "tailSeconds-message",
          "maxclass": "newobj",
          "text": "prepend tailSeconds",
          "patching_rect": [
            400,
            548,
            160,
            22
          ]
        }
      },
      {
        "box": {
          "id": "normalize",
          "maxclass": "live.text",
          "patching_rect": [
            12,
            97,
            74,
            20
          ],
          "presentation": 1,
          "presentation_rect": [
            12,
            97,
            74,
            20
          ],
          "text": "Normalize",
          "texton": "Normalize",
          "mode": 1
        }
      },
      {
        "box": {
          "id": "normalize-default",
          "maxclass": "newobj",
          "text": "loadmess set 1",
          "patching_rect": [
            200,
            584,
            120,
            22
          ]
        }
      },
      {
        "box": {
          "id": "normalize-message",
          "maxclass": "newobj",
          "text": "prepend normalize",
          "patching_rect": [
            400,
            584,
            160,
            22
          ]
        }
      },
      {
        "box": {
          "id": "overwrite",
          "maxclass": "live.text",
          "patching_rect": [
            92,
            97,
            130,
            20
          ],
          "presentation": 1,
          "presentation_rect": [
            92,
            97,
            130,
            20
          ],
          "text": "Overwrite Existing Previews",
          "texton": "Overwrite Existing Previews",
          "mode": 1
        }
      },
      {
        "box": {
          "id": "overwrite-default",
          "maxclass": "newobj",
          "text": "loadmess set 0",
          "patching_rect": [
            200,
            620,
            120,
            22
          ]
        }
      },
      {
        "box": {
          "id": "overwrite-message",
          "maxclass": "newobj",
          "text": "prepend overwrite",
          "patching_rect": [
            400,
            620,
            160,
            22
          ]
        }
      },
      {
        "box": {
          "id": "cutSilence",
          "maxclass": "live.text",
          "patching_rect": [
            228,
            97,
            74,
            20
          ],
          "presentation": 1,
          "presentation_rect": [
            228,
            97,
            74,
            20
          ],
          "text": "Cut Silence",
          "texton": "Cut Silence",
          "mode": 1
        }
      },
      {
        "box": {
          "id": "cutSilence-default",
          "maxclass": "newobj",
          "text": "loadmess set 1",
          "patching_rect": [
            200,
            656,
            120,
            22
          ]
        }
      },
      {
        "box": {
          "id": "cutSilence-message",
          "maxclass": "newobj",
          "text": "prepend cutSilence",
          "patching_rect": [
            400,
            656,
            160,
            22
          ]
        }
      },
      {
        "box": {
          "id": "picker-click",
          "maxclass": "newobj",
          "text": "t b",
          "patching_rect": [
            200,
            145,
            45,
            22
          ]
        }
      },
      {
        "box": {
          "id": "picker-label",
          "maxclass": "newobj",
          "text": "prepend set",
          "patching_rect": [
            780,
            280,
            90,
            22
          ]
        }
      },
      {
        "box": {
          "id": "midi-click",
          "maxclass": "newobj",
          "text": "t b",
          "patching_rect": [
            430,
            120,
            45,
            22
          ]
        }
      }
    ],
    "lines": [
      {
        "patchline": {
          "source": [
            "note-default",
            0
          ],
          "destination": [
            "note",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "note",
            0
          ],
          "destination": [
            "note-message",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "note-message",
            0
          ],
          "destination": [
            "obj-24",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "velocity-default",
            0
          ],
          "destination": [
            "velocity",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "velocity",
            0
          ],
          "destination": [
            "velocity-message",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "velocity-message",
            0
          ],
          "destination": [
            "obj-24",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "noteSeconds-default",
            0
          ],
          "destination": [
            "noteSeconds",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "noteSeconds",
            0
          ],
          "destination": [
            "noteSeconds-message",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "noteSeconds-message",
            0
          ],
          "destination": [
            "obj-24",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "tailSeconds-default",
            0
          ],
          "destination": [
            "tailSeconds",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "tailSeconds",
            0
          ],
          "destination": [
            "tailSeconds-message",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "tailSeconds-message",
            0
          ],
          "destination": [
            "obj-24",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "normalize-default",
            0
          ],
          "destination": [
            "normalize",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "normalize",
            0
          ],
          "destination": [
            "normalize-message",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "normalize-message",
            0
          ],
          "destination": [
            "obj-24",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "overwrite-default",
            0
          ],
          "destination": [
            "overwrite",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "overwrite",
            0
          ],
          "destination": [
            "overwrite-message",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "overwrite-message",
            0
          ],
          "destination": [
            "obj-24",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "cutSilence-default",
            0
          ],
          "destination": [
            "cutSilence",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "cutSilence",
            0
          ],
          "destination": [
            "cutSilence-message",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "cutSilence-message",
            0
          ],
          "destination": [
            "obj-24",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "midi-picker",
            0
          ],
          "destination": [
            "midi-click",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "midi-click",
            0
          ],
          "destination": [
            "midi-choose-message",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "midi-choose-message",
            0
          ],
          "destination": [
            "obj-24",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "midi-clear",
            0
          ],
          "destination": [
            "midi-clear-message",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "midi-clear-message",
            0
          ],
          "destination": [
            "obj-24",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "status-route",
            3
          ],
          "destination": [
            "midi-label",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "midi-label",
            0
          ],
          "destination": [
            "midi-picker",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "rack-picker",
            0
          ],
          "destination": [
            "rack-click",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "rack-click",
            0
          ],
          "destination": [
            "rack-message",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "rack-message",
            0
          ],
          "destination": [
            "obj-24",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "status-route",
            2
          ],
          "destination": [
            "rack-label",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "rack-label",
            0
          ],
          "destination": [
            "rack-picker",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "choose",
            0
          ],
          "destination": [
            "picker-click",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "picker-click",
            0
          ],
          "destination": [
            "folder-message",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "status-route",
            1
          ],
          "destination": [
            "picker-label",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "picker-label",
            0
          ],
          "destination": [
            "choose",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "folder-message",
            0
          ],
          "destination": [
            "obj-24",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "cancel",
            0
          ],
          "destination": [
            "cancel-message",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "cancel-message",
            0
          ],
          "destination": [
            "obj-24",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "batch",
            0
          ],
          "destination": [
            "start-message",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "start-message",
            0
          ],
          "destination": [
            "obj-24",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-2",
            0
          ],
          "destination": [
            "obj-3",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-2",
            1
          ],
          "destination": [
            "obj-3",
            1
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-2",
            0
          ],
          "destination": [
            "obj-5",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-2",
            1
          ],
          "destination": [
            "obj-5",
            1
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-7",
            0
          ],
          "destination": [
            "obj-5",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-7",
            1
          ],
          "destination": [
            "obj-24",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-24",
            0
          ],
          "destination": [
            "obj-300",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-300",
            0
          ],
          "destination": [
            "obj-7",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-300",
            1
          ],
          "destination": [
            "status-route",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "status-route",
            0
          ],
          "destination": [
            "status-set",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "status-set",
            0
          ],
          "destination": [
            "status",
            0
          ]
        }
      }
    ],
    "dependency_cache": [
      {
        "name": "batch.js",
        "bootpath": ".",
        "type": "TEXT",
        "implicit": 1
      },
      {
        "name": "capture.js",
        "bootpath": ".",
        "type": "TEXT",
        "implicit": 1
      },
      {
        "name": "wav.js",
        "bootpath": ".",
        "type": "TEXT",
        "implicit": 1
      },
      {
        "name": "midi.js",
        "bootpath": ".",
        "type": "TEXT",
        "implicit": 1
      }
    ],
    "autosave": 0
  }
}
