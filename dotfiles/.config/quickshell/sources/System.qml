pragma Singleton

import Quickshell
import Quickshell.Io
import QtQuick
import qs.globals

Singleton {
    id: root

    property real temperature
    property real load
    property string usedMemory
    property real usedMemoryf: parseFloat(usedMemory)
    property string totalMemory
    property real totalMemoryf: parseFloat(totalMemoryf)
    property real percentMemory: usedMemoryf / totalMemoryf

    Process {
        id: tempProc
        command: ["sh", "-c", "acpi -t | awk '{print $4}'"]

        stdout: StdioCollector {
            onStreamFinished: {
                try {
                    const output = this.text.trim();
                    root.temperature = output;
                } catch (e) {
                    console.log("failed to parse CPU temp", e);
                }
            }
        }
    }
    Process {
        id: memProc
        command: ["sh", "-c", "free -h | awk \'/^Mem:/ {print $3, $2}'"]
        running: true

        stdout: StdioCollector {
            onStreamFinished: {
                try {
                    const output = this.text.trim().split(" ");
                    if (output.length === 2) {
                        root.usedMemory = output[0];
                        root.totalMemory = output[1];
                    }
                } catch (e) {
                    console.log("failed to parse memory usage;", e);
                }
            }
        }
    }

    function runProcesses() {
        tempProc.running = true;
        memProc.running = true;
    }

    function sortVariables() {
        root.usedMemoryf = parseFloat(root.usedMemory);
        root.totalMemoryf = parseFloat(root.totalMemory);
        root.percentMemory = root.usedMemoryf / root.totalMemoryf;
    }

    Timer {
        interval: Variables.timerProcInterval
        repeat: true
        running: true
        onTriggered: {
            root.runProcesses();
            root.sortVariables();
        }
    }
}
