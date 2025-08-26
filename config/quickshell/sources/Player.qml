pragma Singleton

import Quickshell
import Quickshell.Io
import QtQuick
import qs.globals

Singleton {
    id: root
    property string trackDisplay
    property string imageUrl
    property real songLength
    property real songPosition
    property bool paused

    Process {
        id: displayNameProc
        running: true
        command: ["playerctl", "metadata", "--format", "{{artist}} - {{title}}"]

        stdout: StdioCollector {
            onStreamFinished: {
                try {
                    root.trackDisplay = this.text.trim();
                } catch (e) {
                    console.log("Failed to parse track", e);
                }
            }
        }
    }

    Process {
        id: imageProc
        running: true
        command: ["playerctl", "metadata", "--format", "{{mpris:artUrl}}"]

        stdout: StdioCollector {
            onStreamFinished: {
                try {
                    root.imageUrl = this.text.trim();
                } catch (e) {
                    console.log("Failed to parse track", e);
                }
            }
        }
    }

    Process {
        id: lengthProc
        running: true
        command: ["playerctl", "metadata", "--format", "{{mpris:length}}"]

        stdout: StdioCollector {
            onStreamFinished: {
                try {
                    root.songLength = parseFloat(this.text.trim() / 1000000); // For some reason the length is in microseconds
                } catch (e) {
                    console.log("Failed to parse track", e);
                }
            }
        }
    }

    Process {
        id: positionProc
        running: true
        command: ["playerctl", "position"]

        stdout: StdioCollector {
            onStreamFinished: {
                try {
                    root.songPosition = parseFloat(this.text.trim());
                } catch (e) {
                    console.log("Failed to parse track", e);
                }
            }
        }
    }

    Process {
        id: statusProc
        running: true
        command: ["playerctl", "status"]

        stdout: StdioCollector {
            onStreamFinished: {
                try {
                    if (this.text.trim() == "Playing") {
                        root.paused = false;
                    } else {
                        root.paused = true;
                    }
                } catch (e) {
                    console.log("failed to parse track", e);
                }
            }
        }
    }

    Timer {
        running: true
        repeat: true
        onTriggered: {
            displayNameProc.running = true, imageProc.running = true;
            lengthProc.running = true, positionProc.running = true;
            statusProc.running = true;
        }
        interval: Variables.timerProcInterval
    }
}
