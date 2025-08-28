// Bar.qml
pragma ComponentBehavior: Bound
import Quickshell
import QtQuick
import QtQuick.Layouts

import qs.bar
import qs.bar.widgets

import qs.functions as F
import qs.globals as G

Scope {
    id: root

    Variants {
        model: Quickshell.screens

        PanelWindow {
            id: window
            required property var modelData
            screen: modelData

            anchors {
                left: true
                top: true
                bottom: true
            }

            color: "transparent"
            implicitWidth: G.Variables.barSize

            Rectangle {
                color: F.Colors.backgroundColor
                implicitHeight: parent.height
                implicitWidth: parent.width

                ColumnLayout {
                    id: mainyout
                    Layout.alignment: Qt.AlignLeft
                    height: parent.height
                    implicitWidth: parent.width

                    WorkspaceWidget {
                        id: workspaces

                        Layout.fillWidth: true
                        Layout.alignment: Qt.AlignTop
                        color: "transparent"
                    }

                    Window {
                        id: spacer

                        implicitHeight: 200
                        Layout.alignment: Qt.AlignHCenter
                    }

                    Windows {
                        Layout.bottomMargin: 10
                        Layout.alignment: Qt.AlignHCenter
                    }

                    Cava {
                        id: cava
                        barY: y

                        Layout.fillWidth: true
                        Layout.alignment: Qt.AlignBottom
                        implicitHeight: 75
                    }

                    TrayWidget {
                        id: tray
                        rectY: y

                        implicitWidth: parent.width
                        Layout.fillWidth: true
                        Layout.alignment: Qt.AlignBottom
                        color: "transparent"
                    }

                    Rectangle {
                        id: widgets
                        implicitWidth: window.width - 2
                        implicitHeight: widgetLayout.implicitHeight + 16  // Add padding
                        color: "transparent"
                        border.color: F.Colors.borderColor
                        border.width: 1
                        radius: 8
                        Layout.alignment: Qt.AlignHCenter
                        Layout.leftMargin: 1

                        ColumnLayout {
                            id: widgetLayout
                            anchors.fill: parent
                            anchors.margins: 8
                            spacing: 5

                            BatteryWidget {
                                Layout.fillWidth: true
                                Layout.alignment: Qt.AlignHCenter
                            }

                            ClockWidget {
                                barY: widgets.y
                                Layout.fillWidth: true
                                Layout.alignment: Qt.AlignHCenter
                            }

                            VolumeWidget {
                                Layout.fillWidth: true
                                Layout.alignment: Qt.AlignHCenter
                                Layout.preferredHeight: implicitHeight || 20
                            }
                        }
                    }

                    DesktopButtons {
                        implicitWidth: parent.width
                        Layout.fillWidth: true
                        Layout.alignment: Qt.AlignBottom
                        Layout.bottomMargin: 6
                    }
                }
            }
        }
    }
}
