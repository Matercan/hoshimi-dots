import Quickshell
import Quickshell.Io
import QtQuick

Scope {
    id: scope
    property string volume

    Process {
        id: audioProc
        command: ["wpctl", "get-volume", "@DEFAULT_AUDIO_SINK@"]
        running: true

        stdout: StdioCollector {
            onStreamFinished: {
                try {
                    scope.volume = this.text;
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
