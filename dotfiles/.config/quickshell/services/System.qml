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
    property real usedSwap
    property real totalSwap
    property real percentSwap

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
    Process {
        id: cpuProc
        command: ["sh", "-c", "iostat | awk 'NR==4 {print $6}'"]
        running: true

        stdout: StdioCollector {
            onStreamFinished: {
                try {
                    const output = this.text.trim();
                    root.load = (100 - parseFloat(output)) / 100;
                } catch (e) {
                    console.log("failed to parse CPU usage", e);
                }
            }
        }
    }
    Process {
        id: swapProc
        command: ["sh", "-c", "grep '^Swap' /proc/meminfo"]
        running: true

        stdout: StdioCollector {
            onStreamFinished: {
                try {
                    const lines = this.text.trim();

                    if (lines.length >= 2) {
                        // Parse SwapTotal line (first line)
                        const totalMatch = lines.match(/SwapTotal:\s*(\d+)/);
                        // Parse SwapFree line (second line)
                        const freeMatch = lines.match(/SwapFree:\s*(\d+)/);

                        if (totalMatch && freeMatch) {
                            const totalSwap = parseInt(totalMatch[1]);
                            const freeSwap = parseInt(freeMatch[1]);

                            root.totalSwap = totalSwap;
                            root.usedSwap = totalSwap - freeSwap;
                        }
                    }
                } catch (e) {
                    console.log("Failed to parse swap:", e.message);
                }
            }
        }
    }

    function runProcesses() {
        tempProc.running = true;
        memProc.running = true;
        cpuProc.running = true;
        swapProc.running = true;
    }

    function sortVariables() {
        root.usedMemoryf = parseFloat(root.usedMemory);
        root.totalMemoryf = parseFloat(root.totalMemory);
        root.percentMemory = root.usedMemoryf / root.totalMemoryf;
        root.percentSwap = root.usedSwap / root.totalSwap;
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
