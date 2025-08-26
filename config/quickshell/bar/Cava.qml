pragma ComponentBehavior: Bound
import Quickshell.Io
import QtQuick

import qs.globals

Rectangle {
    id: root
    color: "transparent"

    Process {
        id: cavaProc
        running: true
        command: ["cava", "-p", "/home/matercan/.config/quickshell/bar/cava"] // replace matercan with your actual username

        property var cavaValues: []

        stdout: SplitParser {
            splitMarker: "\n"

            onRead: {
                if (!data)
                    return;

                var line = data.trim();
                if (!line)
                    return;

                var parts = line.split(";");
                if (parts.length === 0)
                    return;

                // Remove empty last element if present
                if (parts[parts.length - 1] === "") {
                    parts.pop();
                }

                var values = [];
                for (var i = 0; i < parts.length; ++i) {
                    var n = parseInt(parts[i], 10);
                    if (!isNaN(n)) {
                        values.push(Math.max(0, n)); // Ensure non-negative values
                    }
                }

                if (values.length > 0) {
                    cavaProc.cavaValues = values;
                }
            }
        }

        onExited: {
            console.log("CAVA process exited with code:", exitCode);
            restartTimer.start();
        }
    }

    Timer {
        id: restartTimer
        interval: 1000
        onTriggered: cavaProc.running = true
    }

    // Container for the bars
    Rectangle {

        width: parent.width
        height: parent.height
        color: "transparent"
        clip: true

        Column {
            anchors.fill: parent
            spacing: 1

            Repeater {
                // Use fewer bars to fit in the smaller widget
                model: Math.min(35, cavaProc.cavaValues.length)

                delegate: Rectangle {
                    required property int index

                    height: 3
                    width: Math.max(1, (cavaProc.cavaValues[Math.floor(index * cavaProc.cavaValues.length / 20)] || 0) * 0.5)
                    color: Qt.hsla((index / 20) * 0.7, 0.8, 0.6, 1.0)
                    radius: 1

                    anchors.horizontalCenter: parent.horizontalCenter

                    Behavior on height {
                        NumberAnimation {
                            duration: MaterialEasing.standardAccel * 0.25
                            easing.type: Easing.OutQuad
                        }
                    }
                }
            }
        }
    }
}
