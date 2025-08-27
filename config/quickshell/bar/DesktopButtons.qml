pragma ComponentBehavior: Bound
import Quickshell
import Quickshell.Io
import QtQuick
import QtQuick.Layouts

import qs.globals
import qs.generics
import qs.functions

MouseArea {
    id: root
    implicitWidth: text.width
    implicitHeight: text.height

    hoverEnabled: true
    cursorShape: Qt.PointingHandCursor
    onPressed: powerOff.running = true
    onEntered: {
        showPopup = true;
        popup.varShow = true;
        autocloseTimer.restart();
    }

    property bool showPopup: false

    Rectangle {
        anchors.centerIn: parent
        implicitHeight: text.height
        implicitWidth: text.height
        radius: width / 3
        color: root.containsMouse ? Colors.transparentize(Colors.getPaletteColor("blue"), 0.3) : "transparent"
    }

    Text {
        id: text
        anchors.centerIn: parent
        text: ""
        color: Colors.getPaletteColor("orange")
    }

    Process {
        id: powerOff
        running: false
        command: ["shutdown", "now"]
    }

    Timer {
        id: autocloseTimer
        running: false
        repeat: false
        interval: Variables.popupMenuOpenTime

        onTriggered: {
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
        property bool mouseWithin
        visible: root.showPopup
        color: "transparent"

        MouseArea {
            id: area
            hoverEnabled: true
            implicitHeight: popup.height
            implicitWidth: popup.width

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

        anchors {
            left: true
            bottom: true
        }

        margins {
            bottom: 6
        }

        PopupBox {
            id: rect
            root: popup
            fullyOpen: popup.fullyOpen
            varShow: popup.varShow

            implicitWidth: layout.width + 10
            implicitHeight: layout.height + 20
            anchors.bottom: parent.bottom

            RowLayout {
                id: layout
                anchors.centerIn: parent
                spacing: 20

                MouseArea {
                    id: lock
                    implicitHeight: lockText.height
                    implicitWidth: lockText.width
                    hoverEnabled: true
                    onClicked: Variables.locked = true
                    cursorShape: Qt.PointingHandCursor

                    Rectangle {
                        anchors.centerIn: parent
                        radius: width / 3
                        implicitWidth: lock.height
                        implicitHeight: lock.height
                        color: lock.containsMouse ? Colors.transparentize(Colors.selectedColor, 0.3) : "transparent"
                    }
                    Text {
                        id: lockText
                        anchors.centerIn: parent
                        text: ""
                    }
                }
                MouseArea {
                    id: reboot
                    implicitWidth: rebootText.width
                    implicitHeight: rebootText.height
                    hoverEnabled: true
                    onClicked: rebootProc.running = true
                    cursorShape: Qt.PointingHandCursor

                    Rectangle {
                        anchors.centerIn: parent
                        radius: width / 3
                        implicitWidth: lock.height
                        implicitHeight: lock.height
                        color: reboot.containsMouse ? Colors.transparentize(Colors.selectedColor, 0.3) : "transparent"
                    }
                    Text {
                        id: rebootText
                        text: "󰜉"
                    }
                    Process {
                        id: rebootProc
                        running: false
                        command: ["reboot"]
                    }
                }
                MouseArea {
                    id: exit
                    implicitHeight: exitText.height
                    implicitWidth: exitText.width
                    hoverEnabled: true
                    onClicked: exitProc.running = true
                    cursorShape: Qt.PointingHandCursor

                    Rectangle {
                        anchors.centerIn: parent
                        radius: width / 3
                        implicitWidth: lock.height
                        implicitHeight: lock.height
                        color: exit.containsMouse ? Colors.transparentize(Colors.selectedColor, 0.3) : "transparent"
                    }
                    Text {
                        id: exitText
                        text: "󰩈"
                    }
                    Process {
                        id: exitProc
                        running: false
                        command: ["hyprctl", "dispatch", "exit"]
                    }
                }
                MouseArea {
                    id: close
                    implicitWidth: closeText.width
                    implicitHeight: closeText.height
                    hoverEnabled: true
                    onClicked: exitProc.running = true
                    cursorShape: Qt.PointingHandCursor

                    Rectangle {
                        anchors.centerIn: parent
                        radius: width / 3
                        implicitWidth: lock.height
                        implicitHeight: lock.height
                        color: close.containsMouse ? Colors.transparentize(Colors.selectedColor, 0.3) : "transparent"
                    }
                    Text {
                        id: closeText
                        text: ""
                    }
                    Process {
                        id: closeProc
                        running: false
                        command: ["killlall", "quickshell"]
                    }
                }
            }
        }
    }
}
