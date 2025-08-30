pragma Singleton

import Quickshell
import Quickshell.Io
import QtQuick
import qs.globals

Singleton {
    id: root
    property string activeSource
    property string trackDisplay
    property string imageUrl
    property real songLength
    property real songPosition
    property bool paused

    Process {
        id: displayNameProc
        running: true
        command: ["playerctl", "metadata", "--format", "{{artist}} - {{title}}", "--player=" + root.activeSource,]

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

    function goNext() {
        getNextSource.running = true;
        pause.running = true;
    }

    Process {
        id: pause
        running: false
        command: ["playerctl", "pause", "--player=" + root.activeSource]
    }

    Process {
        id: getNextSource
        running: false
        command: [Quickshell.env("HOME") + "/.config/quickshell/sources/NextPlayer.sh"]
        stdout: StdioCollector {
            onStreamFinished: {
                activateSource.source = this.text.trim();
                activateSource.running = true;
            }
        }
    }

    Process {
        id: activateSource
        property string source
        running: false
        command: ["playerctl", "play", source]
    }

    Process {
        id: imageProc
        running: true
        command: ["playerctl", "metadata", "--format", "{{mpris:artUrl}}", "--player=" + root.activeSource]

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
        id: activeSourceProc
        running: true
        command: [Quickshell.env("HOME") + "/.config/quickshell/sources/ActivePlayer.sh"]

        stdout: StdioCollector {
            onStreamFinished: {
                try {
                    if (this.text.trim() != "null")
                        root.activeSource = this.text.trim();
                } catch (e) {
                    console.log("failed to parse track", e);
                }
            }
        }
    }

    Process {
        id: lengthProc
        running: true
        command: ["playerctl", "metadata", "--format", "{{mpris:length}}", "--player=" + root.activeSource]

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
        command: ["playerctl", "position", "--player=" + root.activeSource]

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
        command: ["playerctl", "status", "--player=" + root.activeSource]

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
            statusProc.running = true, activeSourceProc.running = true;
        }
        interval: Variables.timerProcInterval * 10
    }
}
