pragma ComponentBehavior: Bound
import QtQuick
import QtQuick.Layouts
import Quickshell.Io

import qs.functions as F
import qs.sources as S
import qs.globals as Glo

Rectangle {
    id: volumeWidget

    // Set proper dimensions
    implicitWidth: layout.width + 8  // Add some padding
    implicitHeight: layout.height + 4

    // Make it fill the available width from the layout
    width: implicitWidth
    height: 15
    color: "transparent"

    ColumnLayout {
        id: layout
        spacing: 0

        Repeater {
            id: indicator
            property list<bool> mouseBool: [false, false, false, false, false, false, false, false, false, false]
            model: 100
            delegate: Rectangle {
                id: bar
                Layout.alignment: Qt.AlignHCenter
                required property var modelData
                color: {
                    var mouseBelow;
                    for (let i = modelData; i >= 0; i--) {
                        if (indicator.mouseBool[i] == true) {
                            mouseBelow = true;
                            break;
                        }
                    }
                    if (area.containsMouse)
                        mouseBelow = true;
                    if (mouseBelow) {
                        return F.Colors.selectedColor;
                    } else if (indicator.model - 1 - modelData <= S.Audio.volumePercent * (indicator.model / 100)) {
                        return F.Colors.getPaletteColor("blue");
                    } else {
                        return F.Colors.getPaletteColor("white");
                    }
                }
                property int curveRadius: 20
                implicitWidth: 10
                implicitHeight: 100 / indicator.model
                topRightRadius: modelData == 0 ? 5 : 0
                topLeftRadius: modelData == 0 ? 5 : 0
                bottomLeftRadius: modelData == indicator.model - 1 ? 5 : 0
                bottomRightRadius: modelData == indicator.model - 1 ? 5 : 0

                MouseArea {
                    id: area
                    hoverEnabled: true
                    anchors.fill: parent
                    cursorShape: Qt.PointingHandCursor
                    onClicked: {
                        console.log("Volume bar clicked, setting volume to:", ((indicator.model - 1 - bar.modelData) / indicator.model));
                        setVolume.running = true;
                    }

                    Process {
                        id: setVolume
                        running: false
                        command: ["wpctl", "set-volume", "@DEFAULT_AUDIO_SINK@", ((indicator.model - 1 - bar.modelData) / indicator.model).toString()]

                        onExited: {
                            console.log("wpctl command finished with exit code:", exitCode);
                            if (exitCode !== 0) {
                                console.log("Volume setting failed");
                            }
                        }
                    }

                    Timer {
                        interval: Glo.Variables.timerProcInterval
                        running: true
                        repeat: true
                        onTriggered: {
                            indicator.mouseBool[bar.modelData] = area.containsMouse;
                        }
                    }
                }
            }
        }

        anchors.centerIn: parent
        Text {
            id: volumeText
            Layout.alignment: Qt.AlignHCenter
            Layout.topMargin: 10

            color: F.Colors.foregroundColor
            font.pixelSize: 12

            rotation: 270
            text: ""

            MouseArea {
                anchors.fill: parent
                cursorShape: Qt.PointingHandCursor
                onClicked: muteVolume.running = true

                Process {
                    id: muteVolume
                    running: false
                    command: ["wpctl", "set-volume", "@DEFAULT_AUDIO_SINK@", "0"]
                }
            }
        }
    }

    Process {
        id: openControl
        command: ["pavucontrol"]
        running: false
    }

    Timer {
        id: autoCloseTimer
        running: false
        repeat: false
        interval: Glo.Variables.popupMenuOpenTime

        onTriggered: popup.varShow = false
    }

    Timer {
        id: closeTimer
        running: false
        repeat: false
        interval: 500

        onTriggered: {
            volumeWidget.showPopup = false;
        }
    }
}
