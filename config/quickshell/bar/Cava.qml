pragma ComponentBehavior: Bound
import Quickshell
import Quickshell.Io
import QtQuick
import QtQuick.Layouts
import QtQuick.Shapes

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
        anchors.centerIn: parent
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
                    gradient: Gradient {
                        orientation: Gradient.Horizontal
                        GradientStop {
                            position: 0.0
                            color: Colors.getPaletteColor("light pink")
                        }
                        GradientStop {
                            position: 0.33
                            color: Colors.getPaletteColor("light blue")
                        }
                        GradientStop {
                            position: 1.0
                            color: Colors.getPaletteColor("yellow")
                        }
                    }
                    radius: 1

                    anchors.left: parent.left

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
        interval: MaterialEasing.emphasizedTime * 0.3

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
            top: root.barY - rect.height / 2
        }

        implicitWidth: rect.width + 50
        implicitHeight: rect.height + 50

        PopupBox {
            id: rect
            root: popup
            fullyOpen: popup.fullyOpen
            anchors.centerIn: parent
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
                    mipmap: true
                    smooth: true
                    fillMode: Image.PreserveAspectFit
                    Layout.alignment: Qt.AlignHCenter
                    Layout.preferredHeight: track.width
                    Layout.preferredWidth: track.width
                }
                Text {
                    id: track
                    Layout.alignment: Qt.AlignHCenter
                    font.pixelSize: {
                        if (Player.trackDisplay.length >= 15) {
                            return 490 / Player.trackDisplay.length;
                        } else {
                            return 20;
                        }
                    }
                    text: Player.trackDisplay
                }

                Item {
                    id: timeDisplay
                    Layout.fillWidth: true
                    Layout.preferredHeight: track.height / 4

                    function formatTime(seconds) {
                        var mins = Math.floor(seconds / 60);
                        var secs = Math.floor(seconds % 60);
                        return mins + ":" + (secs < 10 ? "0" : "") + secs;
                    }

                    Row {
                        anchors.fill: parent
                        spacing: 8

                        // Current position text
                        Text {
                            id: currentTimeText
                            anchors.verticalCenter: parent.verticalCenter
                            font.pixelSize: 12
                            color: Colors.selectedColor
                            text: timeDisplay.formatTime(Player.songPosition)
                            width: 35 // Fixed width to prevent jumping
                        }

                        // Progress bar container
                        Item {
                            anchors.verticalCenter: parent.verticalCenter
                            width: parent.width - currentTimeText.width - totalTimeText.width - 16 // Account for spacing
                            height: parent.height

                            // Background bar
                            Rectangle {
                                id: progressBar
                                anchors.centerIn: parent
                                width: parent.width
                                height: currentTimeText.height / 4
                                radius: 10
                                gradient: Gradient {
                                    orientation: Gradient.Horizontal

                                    GradientStop {
                                        position: Player.songPosition / Player.songLength
                                        color: Colors.backgroundColor
                                    }
                                    GradientStop {
                                        position: 1
                                        color: Colors.getPaletteColor("blue")
                                    }
                                }
                            }

                            Rectangle {
                                id: separator
                                anchors.verticalCenter: parent.verticalCenter
                                x: parent.width * (Player.songPosition / Player.songLength)
                                radius: 5
                                height: currentTimeText.height / 2
                                width: 5
                                color: Colors.selectedColor
                            }

                            // Progress fill
                            Rectangle {
                                anchors.left: progressBar.left
                                anchors.verticalCenter: progressBar.verticalCenter
                                height: progressBar.height
                                width: Math.max(0, Math.min(progressBar.width, (Player.songPosition / Player.songLength) * progressBar.width))
                                radius: 0
                                gradient: Gradient {
                                    orientation: Gradient.Horizontal

                                    GradientStop {
                                        position: 0
                                        color: Colors.transparentize(Colors.interpolate(Colors.getPaletteColor("light blue"), Colors.getPaletteColor("light green"), Player.songPosition / Player.songLength), 0.2)
                                    }
                                    GradientStop {
                                        position: Player.songPosition / Player.songLength
                                        color: Colors.transparentize(Colors.interpolate(Colors.getPaletteColor("red"), Colors.getPaletteColor("blue"), Player.songPosition / Player.songLength), 0.2)
                                    }
                                }
                            }
                        }

                        // Total time text
                        Text {
                            id: totalTimeText
                            anchors.verticalCenter: parent.verticalCenter
                            font.pixelSize: 12
                            color: Colors.selectedColor
                            text: timeDisplay.formatTime(Player.songLength)
                            width: 35 // Fixed width to prevent jumping
                        }
                    }
                }

                RowLayout {
                    id: buttons
                    spacing: 6

                    Layout.alignment: Qt.AlignHCenter
                    property var hoverColor: Colors.transparentize(Colors.getPaletteColor("blue"), 0.7)
                    property var normalColor: Colors.transparentize(Colors.getPaletteColor("light pink"), 0.7)

                    MouseArea {
                        Layout.alignment: Qt.AlignCenter
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
                            command: ["playerctl", "previous", "--player=" + Player.activeSource]
                        }
                        onClicked: previous.running = true
                    }
                    MouseArea {
                        hoverEnabled: true
                        implicitWidth: track.width / 4
                        implicitHeight: playPause.height
                        Layout.alignment: Qt.AlignCenter
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
                            command: ["playerctl", "play-pause", "--player=" + Player.activeSource]
                        }
                        onClicked: plapau.running = true
                    }
                    MouseArea {
                        Layout.alignment: Qt.AlignCenter
                        hoverEnabled: true
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
                            command: ["playerctl", "next", "--player=" + Player.activeSource]
                        }
                        onClicked: next.running = true
                    }
                }
            }
        }
    }
}
