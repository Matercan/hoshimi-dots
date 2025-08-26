pragma ComponentBehavior: Bound
import Quickshell
import Quickshell.Io
import QtQuick
import QtQuick.Layouts

import qs.globals
import qs.generics
import qs.sources
import qs.functions

MouseArea {
    id: root

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
                            duration: MaterialEasing.standardAccel * 0.1
                            easing.type: Easing.OutQuad
                        }
                    }
                }
            }
        }
    }

    property bool showPopup
    required property int barY

    hoverEnabled: true
    onEntered: {
        showPopup = true;
        popup.varShow = true;
        autoCloseTimer.restart();
    }

    Timer {
        id: autoCloseTimer
        running: false
        repeat: false
        interval: Variables.popupMenuOpenTime

        onTriggered: {
            console.log("Is the mouse in it? " + popup.mouseWithin);
            if (!popup.mouseWithin)
                popup.varShow = false;
        }
    }

    Timer {
        id: closeTimer
        running: false
        repeat: false
        interval: Variables.popupMenuOpenTime

        onTriggered: root.showPopup = false
    }

    PanelWindow {
        id: popup
        property bool varShow
        property bool fullyOpen
        property bool mouseWithin: area.containsMouse
        visible: root.showPopup
        color: "transparent"

        anchors {
            left: true
            top: true
        }

        margins {
            top: root.barY
        }

        implicitWidth: rect.width + 50
        implicitHeight: rect.height + 50

        PopupBox {
            id: rect
            root: popup
            fullyOpen: popup.fullyOpen
            varShow: popup.varShow
            implicitHeight: layout.height + 10
            implicitWidth: layout.width + 10

            MouseArea {
                id: area
                hoverEnabled: true
                implicitHeight: rect.height
                implicitWidth: rect.width

                onExited: {
                    console.log("LEFT");
                    stayOpenTimer.restart();
                }

                Timer {
                    running: true
                    repeat: true
                    onTriggered: popup.mouseWithin = area.containsMouse
                }

                Timer {
                    id: stayOpenTimer
                    running: false
                    repeat: false
                    interval: 1000
                    onTriggered: {
                        if (!area.containsMouse) {
                            popup.varShow = false;
                            closeTimer.restart();
                        }
                    }
                }
            }

            ColumnLayout {
                id: layout
                anchors.centerIn: parent
                implicitWidth: Math.max(track.width, buttons.width) + 10
                implicitHeight: track.height + buttons.height

                Image {
                    id: albumCover
                    source: Player.imageUrl
                    Layout.alignment: Qt.AlignHCenter
                    Layout.preferredWidth: track.width
                    Layout.preferredHeight: track.width
                }

                Text {
                    id: track
                    Layout.alignment: Qt.AlignHCenter
                    text: Player.trackDisplay
                }
                Item {
                    Layout.fillWidth: true
                    Layout.preferredHeight: track.height / 2

                    Rectangle {
                        anchors.fill: parent
                        radius: 10
                        color: Colors.getPaletteColor("blue")
                    }

                    Rectangle {
                        anchors.left: parent.left
                        anchors.top: parent.top
                        anchors.bottom: parent.bottom
                        radius: 10
                        implicitHeight: 10
                        color: Colors.transparentize(Colors.getPaletteColor("light pink"), 0.5)
                        implicitWidth: Player.songPosition / Player.songLength * parent.width
                    }
                }

                RowLayout {
                    id: buttons
                    spacing: 6
                    Layout.preferredWidth: track.width

                    Layout.alignment: Qt.AlignHCenter
                    property var hoverColor: Colors.transparentize(Colors.getPaletteColor("blue"), 0.7)
                    property var normalColor: Colors.transparentize(Colors.getPaletteColor("light pink"), 0.7)

                    MouseArea {
                        Layout.leftMargin: 6
                        Layout.alignment: Qt.AlignLeft
                        implicitWidth: track.width / 4
                        implicitHeight: leftArrow.height
                        cursorShape: Qt.PointingHandCursor
                        hoverEnabled: true

                        Text {
                            id: leftArrow
                            anchors.centerIn: parent
                            text: ""
                        }
                        Rectangle {
                            radius: 5
                            implicitWidth: parent.width
                            implicitHeight: parent.height
                            color: parent.containsMouse ? buttons.hoverColor : buttons.normalColor
                        }
                        Process {
                            id: previous
                            running: false
                            command: ["playerctl", "previous"]
                        }
                        onClicked: previous.running = true
                    }
                    MouseArea {
                        hoverEnabled: true
                        implicitWidth: track.width / 4
                        implicitHeight: playPause.height
                        Layout.alignment: Qt.AlignHCenter
                        cursorShape: Qt.PointingHandCursor

                        Text {
                            id: playPause
                            anchors.centerIn: parent
                            text: Player.paused ? "" : ""
                        }
                        Rectangle {
                            radius: 5
                            implicitWidth: parent.width
                            implicitHeight: parent.height
                            color: parent.containsMouse ? buttons.hoverColor : buttons.normalColor
                        }
                        Process {
                            id: plapau
                            running: false
                            command: ["playerctl", "play-pause"]
                        }
                        onClicked: plapau.running = true
                    }
                    MouseArea {
                        hoverEnabled: true
                        Layout.alignment: Qt.AlignRight
                        Layout.rightMargin: 6
                        implicitHeight: rightArrow.height
                        implicitWidth: track.width / 4
                        cursorShape: Qt.PointingHandCursor

                        Text {
                            id: rightArrow
                            anchors.centerIn: parent
                            text: ""
                        }
                        Rectangle {
                            radius: 5
                            implicitWidth: parent.width
                            implicitHeight: parent.height
                            color: parent.containsMouse ? buttons.hoverColor : buttons.normalColor
                        }
                        Process {
                            id: next
                            running: false
                            command: ["playerctl", "next"]
                        }
                        onClicked: next.running = true
                    }
                }
            }

            Rectangle {
                implicitHeight: 15
                implicitWidth: 15
                color: "black"
            }
        }
    }
}
