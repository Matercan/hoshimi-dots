pragma Singleton
import Quickshell
import Quickshell.Io
import QtQuick

Singleton {
    id: scope
    property string volume

    Process {
        id: audioProc
        command: ["sh", "-c", "wpctl get-volume @DEFAULT_AUDIO_SINK@ | awk '{print $2}'"]
        running: true

        stdout: StdioCollector {
            onStreamFinished: {
                try {
                    scope.volume = (parseFloat(this.text) * 100).toString() + "%";
                } catch (e) {
                    console.log("failed to parse volume", e);
                }
            }
        }
    }
    Timer {
        interval: 100
        repeat: true
        running: true
        onTriggered: audioProc.running = true
    }
}
