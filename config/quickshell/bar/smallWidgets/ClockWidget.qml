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

    implicitWidth: layout.width
    implicitHeight: layout.height

    // Get current time and split it
    property string currentTime: S.Time.time
    property string hours: currentTime.split(":")[0]
    property string minutes: currentTime.split(":")[1]

    property string currentDate: S.Time.date
    property string day: currentDate.split(" ")[0]
    property string month: currentDate.split(" ")[1]

    property bool showPopup
    required property int barY

    L.ColumnLayout {
        id: layout
        anchors.centerIn: parent
        spacing: 2

        // Date section with diagonal slash layout
        Rectangle {
            L.Layout.alignment: Qt.AlignTop
            color: "transparent"
            implicitWidth: 40
            implicitHeight: 35

            // Use Item for manual positioning instead of Layout
            Item {
                anchors.topMargin: 6
                anchors.fill: parent
                anchors.margins: 4

                Rectangle {
                    anchors.top: parent.top
                    anchors.left: parent.left
                    implicitWidth: dayText.width
                    implicitHeight: dayText.height
                    color: "transparent"

                    Text {
                        id: dayText
                        anchors.centerIn: parent
                        text: clockWidget.day
                        color: F.Colors.foregroundColor
                        font.family: G.Variables.fontFamily || "monospace"
                        font.pixelSize: 12
                        font.bold: true
                    }
                }

                // Slash (center)
                Text {
                    id: slashText
                    anchors.centerIn: parent
                    text: "/"
                    color: F.Colors.foregroundColor
                    font.family: G.Variables.fontFamily || "monospace"
                    font.pixelSize: 14
                    font.bold: true
                    opacity: 1
                }

                Rectangle {
                    anchors.bottom: parent.bottom
                    anchors.right: parent.right
                    implicitWidth: monthText.width
                    implicitHeight: monthText.height
                    anchors.rightMargin: 6
                    color: "transparent"

                    Text {
                        id: monthText
                        anchors.centerIn: parent
                        text: clockWidget.getMonthNum(clockWidget.month)
                        color: F.Colors.foregroundColor
                        font.family: G.Variables.fontFamily || "monospace"
                        font.pixelSize: 14
                        font.bold: true
                    }
                }
            }
        }

        // Time section
        Rectangle {
            L.Layout.alignment: Qt.AlignCenter
            implicitWidth: 40
            implicitHeight: 45
            color: "transparent"

            L.ColumnLayout {
                id: timeLayout
                anchors.centerIn: parent
                spacing: -2

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
        }
    }

    hoverEnabled: true
    onClicked: openPeaclock.running = true
    onEntered: {
        showPopup = true;
        popup.varShow = true;
        autoCloseTimer.restart();
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

    Timer {
        id: autoCloseTimer
        running: false
        repeat: false
        interval: G.Variables.popupMenuOpenTime

        onTriggered: popup.varShow = false
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
            top: true
        }

        margins {
            top: clockWidget.barY
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

    function getMonthNum(name: string): int {
        switch (name.toLowerCase()) {
        case "jan":
            return 1;
        case "feb":
            return 2;
        case "mar":
            return 3;
        case "apr":
            return 4;
        case "may":
            return 5;
        case "jun":
            return 6;
        case "jul":
            return 7;
        case "aug":
            return 8;
        case "sep":
            return 9;
        case "oct":
            return 10;
        case "nov":
            return 11;
        case "dec":
            return 12;
        default:
            return 0;
        }
    }
}
