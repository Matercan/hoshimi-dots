import Quickshell
import Quickshell.Io
import QtQuick

Scope {
    id: scope
    property string memoryUsed
    property string totalMemory

    Process {
        id: memProc
        command: ["sh", "-c", "free -h | awk \'/^Mem:/ {print $3, $2}'"]
        running: true

        stdout: StdioCollector {
            onStreamFinished: {
                try {
                    const output = this.text.trim().split(" ");
                    if (output.length === 2) {
                        scope.memoryUsed = output[0];
                        scope.totalMemory = output[1];
                    }
                } catch (e) {
                    console.log("failed to parse memory usage;", e);
                }
            }
        }
    }
    Timer {
        interval: 100
        repeat: true
        running: true
        onTriggered: memProc.running = true
    }
}
