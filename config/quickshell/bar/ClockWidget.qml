import QtQuick
import Quickshell
import QtQuick.Layouts as L
import Quickshell.Io
import Quickshell.Wayland

import qs.functions as F
import qs.sources as S
import qs.globals as G
import qs.generics as Gen

MouseArea {
    id: clockWidget

    implicitWidth: Math.max(hoursText.implicitWidth, minutesText.implicitWidth) + 16
    implicitHeight: timeLayout.implicitHeight + 12

    // Get current time and split it
    property string currentTime: S.Time.time
    property string hours: currentTime.split(":")[0]
    property string minutes: currentTime.split(":")[1]

    property bool showPopup

    L.ColumnLayout {
        id: timeLayout
        anchors.centerIn: parent
        spacing: -2  // Bring rows closer together

        Text {
            id: hoursText
            text: clockWidget.hours
            color: F.Colors.foregroundColor
            font.family: G.Variables.fontFamily || "monospace"
            font.pixelSize: 16
            font.bold: true
            L.Layout.alignment: Qt.AlignHCenter
        }

        Text {
            id: minutesText
            text: clockWidget.minutes
            color: F.Colors.foregroundColor
            font.family: G.Variables.fontFamily || "monospace"
            font.pixelSize: 16
            font.bold: true
            L.Layout.alignment: Qt.AlignHCenter
        }
    }

    hoverEnabled: true
    onClicked: openPeaclock.running = true
    onEntered: {
        showPopup = true;
        popup.varShow = true;
    }

    // Add visual feedback on hover/click
    Rectangle {
        anchors.fill: parent
        color: parent.containsMouse ? F.Colors.selectedColor : "transparent"
        radius: 4
        z: -1  // Behind the text
        opacity: 0.3
    }

    Process {
        id: openPeaclock
        command: ["ghostty", "-e", "peaclock"]
        running: false
    }

    Timer {
        id: closeTimer
        running: false
        repeat: false
        interval: 500

        onTriggered: {
            clockWidget.showPopup = false;
        }
    }

    PanelWindow {
        id: popup
        property bool varShow
        property bool fullyOpen: false
        WlrLayershell.layer: WlrLayer.Top
        visible: clockWidget.showPopup

        MouseArea {
            implicitHeight: parent.height + 50
            implicitWidth: parent.width + 50
            anchors.verticalCenter: parent.verticalCenter
            anchors.horizontalCenter: parent.left
            hoverEnabled: true

            onExited: {
                popup.varShow = false;
                closeTimer.restart();
            }
        }

        anchors {
            left: true
            bottom: true
        }

        margins {
            bottom: 1080 / 2 + 30
        }

        color: "transparent"

        implicitWidth: rect.width + 50
        implicitHeight: rect.height + 50

        Gen.PopupBox {
            id: rect
            root: popup
            fullyOpen: popup.fullyOpen
            varShow: popup.varShow
            radius: 10
            implicitWidth: textDisplay.width + 10
            implicitHeight: textDisplay.height + 10

            L.ColumnLayout {
                id: textDisplay
                anchors.centerIn: parent
                visible: !rect.closedAnimRunning

                Text {
                    L.Layout.alignment: Qt.AlignCenter
                    text: S.Time.time
                    color: F.Colors.foregroundColor
                    font.family: G.Variables.fontFamily
                }

                Text {
                    L.Layout.alignment: Qt.AlignCenter
                    text: S.Time.date
                    color: F.Colors.foregroundColor
                    font.family: G.Variables.fontFamily
                }
            }
        }
    }
}
