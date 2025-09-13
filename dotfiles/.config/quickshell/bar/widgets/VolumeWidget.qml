pragma ComponentBehavior: Bound
import QtQuick
import QtQuick.Layouts
import QtQuick.Effects
import Qt5Compat.GraphicalEffects
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
            id: fullRect
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

            Rectangle {
                id: recto
                anchors.fill: parent
                property real volumeHeight: S.Audio.volumePercent / 100
                color: F.Colors.foregroundColor

                Rectangle {
                    anchors.horizontalCenter: parent.horizontalCenter
                    anchors.bottom: parent.bottom
                    height: parent.height * recto.volumeHeight
                    width: parent.width

                    gradient: Gradient {
                        orientation: Gradient.Vertical

                        GradientStop {
                            color: F.Colors.getPaletteColor("red")
                            position: 1
                        }
                        GradientStop {
                            color: F.Colors.getPaletteColor("blue")
                            position: 1 - recto.volumeHeight
                        }
                    }
                }

                Rectangle {
                    visible: area.containsMouse

                    anchors.horizontalCenter: parent.horizontalCenter
                    anchors.bottom: parent.bottom
                    height: parent.height * area.volumeSet
                    width: parent.width

                    gradient: Gradient {
                        orientation: Gradient.Vertical

                        GradientStop {
                            color: F.Colors.interpolate(F.Colors.getPaletteColor("red"), F.Colors.selectedColor, 0.5)
                            position: 1
                        }
                        GradientStop {
                            color: F.Colors.interpolate(F.Colors.getPaletteColor("blue"), F.Colors.selectedColor, 0.5)
                            position: 1 - recto.volumeHeight
                        }
                    }
                }

                Process {
                    id: volumeProc
                    running: false
                    command: ["wpctl", "set-volume", "@DEFAULT_AUDIO_SINK@", area.volumeSet]
                }

                MouseArea {
                    id: area
                    anchors.fill: parent
                    cursorShape: Qt.PointingHandCursor
                    hoverEnabled: true
                    property real volumeSet: 1 - (mouseY / height)

                    onClicked: volumeProc.running = true
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

            ColorOverlay {
                source: volumeText
                color: F.Colors.transparentize(F.Colors.foregroundColor, 0.3)
                anchors.fill: parent
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
