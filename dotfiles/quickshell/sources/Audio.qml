pragma Singleton
import Quickshell
import Quickshell.Io
import QtQuick

import qs.globals as G

Singleton {
    id: scope
    property string volume
    property real volumePercent

    Process {
        id: audioProc
        command: ["sh", "-c", "wpctl get-volume @DEFAULT_AUDIO_SINK@ | awk '{print $2}'"]
        running: true

        stdout: StdioCollector {
            onStreamFinished: {
                try {
                    scope.volumePercent = parseFloat(this.text) * 100;
                    scope.volume = (parseFloat(this.text) * 100).toString() + "%";
                } catch (e) {
                    console.log("failed to parse volume", e);
                }
            }
        }
    }
    Timer {
        interval: G.Variables.timerProcInterval
        repeat: true
        running: true
        onTriggered: audioProc.running = true
    }
}
