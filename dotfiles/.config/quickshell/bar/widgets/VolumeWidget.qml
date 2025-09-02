pragma ComponentBehavior: Bound
import QtQuick
import QtQuick.Layouts
import QtQuick.Effects
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

        Rectangle {
            radius: 10
            implicitHeight: 100
            implicitWidth: 10
            Layout.alignment: Qt.AlignHCenter

            // Hack to round edges
            layer.enabled: true
            layer.effect: MultiEffect {
                maskSource: mask
                maskEnabled: true
                maskInverted: false
                maskThresholdMin: 0.5
                maskSpreadAtMin: 1
            }

            Item {
                id: mask

                anchors.fill: parent
                layer.enabled: true
                visible: false

                Rectangle {
                    radius: 5
                    implicitWidth: parent.width
                    implicitHeight: parent.height
                    anchors.centerIn: parent
                }
            }

            ColumnLayout {
                id: column
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
                                return F.Colors.interpolate(F.Colors.selectedColor, F.Colors.interpolate(F.Colors.getPaletteColor("red"), F.Colors.getPaletteColor("blue"), modelData / S.Audio.volumePercent), 0.5);
                            } else if (indicator.model - 1 - modelData <= S.Audio.volumePercent * (indicator.model / 100)) {
                                return F.Colors.interpolate(F.Colors.getPaletteColor("red"), F.Colors.getPaletteColor("blue"), modelData / S.Audio.volumePercent);
                            } else {
                                return F.Colors.foregroundColor;
                            }
                        }
                        property int curveRadius: 20
                        implicitWidth: 10
                        implicitHeight: 100 / indicator.model
                        y: implicitHeight * modelData
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
            }
        }

        anchors.centerIn: parent
        Image {
            id: volumeText
            Layout.alignment: Qt.AlignHCenter
            Layout.topMargin: 10

            source: {
                function getAudio() {
                    var iconDirectory = Glo.Variables.statusDirectory;
                    if (S.Audio.volumePercent >= 70) {
                        return iconDirectory + "audio-volume-high-symbolic.svg";
                    } else if (S.Audio.volumePercent >= 40) {
                        return iconDirectory + "audio-volume-medium-symbolic.svg";
                    } else if (S.Audio.volumePercenit >= 0) {
                        return iconDirectory + "audio-volume-low-symbolic.svg";
                    } else {
                        return iconDirectory + "audio-volume-muted-symbolic.svg";
                    }
                }
                return getAudio() || "/usr/share/icons/Adwaita/symbolic/status/audio-volume-high-symbolic-rtl.svg";
            }
            Layout.preferredWidth: 15
            Layout.preferredHeight: 15

            MouseArea {
                id: speakerButton
                anchors.fill: parent
                cursorShape: Qt.PointingHandCursor
                property real beforeMute
                onClicked: {
                    console.log(beforeMute);
                    console.log(S.Audio.volume);
                    if (S.Audio.volume != "0%") {
                        beforeMute = S.Audio.volumePercent / 100;
                        muteVolume.running = true;
                    } else {
                        undoMute.running = true;
                    }
                }

                Process {
                    id: muteVolume
                    running: false
                    command: ["wpctl", "set-volume", "@DEFAULT_AUDIO_SINK@", "0"]
                }
                Process {
                    id: undoMute
                    running: false
                    command: ["wpctl", "set-volume", "@DEFAULT_AUDIO_SINK@", speakerButton.beforeMute.toString()]
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
