import Quickshell
import Quickshell.Io
import QtQuick

Scope {
    id: scope
    property string cpuUsage

    Process {
        id: cpuProc
        command: ["sh", "-c", "top -bn1 | grep 'Cpu(s)' | awk '{print $2}' | sed 's/%us,//'"]
        running: true

        stdout: StdioCollector {
            onStreamFinished: {
                const usage = parseFloat(this.text.trim());
                if (!isNaN(usage)) {
                    scope.cpuUsage = Math.round(usage);
                }
            }
        }
    }

    Timer {
        interval: 2000  // Update every 2 seconds
        repeat: true
        running: true
        onTriggered: cpuProc.running = true
    }
}
