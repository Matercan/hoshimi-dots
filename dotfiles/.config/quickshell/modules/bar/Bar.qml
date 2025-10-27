// Bar.qml
pragma ComponentBehavior: Bound
import Quickshell
import Quickshell.Io
import QtQuick
import QtQuick.Layouts
import QtMultimedia
import Quickshell.Wayland

import qs.functions
import qs.globals
import "./components"

Scope {
    id: root

    Process {
        id: sfx
        command: ["mpv", Quickshell.env("HOME") + "/.config/quickshell/modules/bar/start.wav"]

        Component.onCompleted: running = true
    }

    Variants {
        model: Quickshell.screens

        PanelWindow {
            id: window
            required property var modelData
            screen: modelData

            anchors {
                top: true
                left: true
                right: true
            }

            Component.onCompleted: {
                WlrLayershell.layer = WlrLayer.Top;
                visible = true;
            }

            visible: false
            implicitHeight: Config.bar.barSize

            Rectangle {

                Component.onCompleted: {
                    color = Colors.palette.m3background;
                }

                Behavior on color {
                    ColorAnimation {
                        duration: MaterialEasing.standardAccelTime
                        easing.bezierCurve: MaterialEasing.standardAccel
                    }
                }

                implicitHeight: parent.height
                implicitWidth: parent.width

                color: "transparent"

                RowLayout {
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.fill: parent

                    Loader {
                        active: true
                        asynchronous: true
                        Layout.preferredHeight: children[0].implicitHeight
                        Layout.preferredWidth: children[0].implicitWidth
                        Layout.leftMargin: Config.bar.wrapSize

                        sourceComponent: WorkspaceWidget {
                            anchors.centerIn: parent
                        }
                    }

                    Rectangle {
                        id: leftSpacer
                        Layout.fillWidth: true
                        color: "transparent"
                    }

                    Loader {
                        asynchronous: true
                        active: false
                        Layout.preferredHeight: children[0].implicitHeight
                        Layout.preferredWidth: children[0].implicitWidth
                        Layout.alignment: Qt.AlignHCenter

                        sourceComponent: Clock {
                            anchors.centerIn: parent
                            Component.onCompleted: {
                                console.log(Status.widgetHeight);
                                Status.setHeight(height);
                            }
                        }
                    }

                    Rectangle {
                        id: rightSpacer
                        Layout.fillWidth: true
                        color: "transparent"
                    }

                    Loader {
                        id: tray
                        active: true
                        asynchronous: true
                        Layout.preferredHeight: children[0].implicitHeight
                        Layout.preferredWidth: children[0].implicitWidth

                        Layout.alignment: Qt.AlignRight

                        sourceComponent: TrayWidget {
                            anchors.centerIn: parent
                            pos: tray.x - tray.width
                            Component.onCompleted: {
                                console.log(Status.widgetHeight);
                                Status.setHeight(height);
                            }
                        }
                    }

                    Rectangle {
                        id: nix
                        implicitHeight: parent.height
                        implicitWidth: 3 * nixLogo.width

                        Layout.rightMargin: Config.bar.wrapSize
                        color: "transparent"

                        Text {
                            id: nixLogo
                            text: " "
                            color: Colors.light ? Colors.palette.m3inverseOnSurface : Colors.palette.m3onSurface
                            anchors.centerIn: parent
                        }

                        Layout.alignment: Qt.AlignRight
                    }
                }
            }
        }
    }
}
