// Bar.qml
pragma ComponentBehavior: Bound
import Quickshell
import QtQuick
import QtQuick.Layouts as L
import "../functions/" as F
import "../sources" as S

Scope {
    id: root

    Variants {
        model: Quickshell.screens

        PanelWindow {
            id: window

            required property var modelData
            screen: modelData

            color: "transparent"

            anchors {
                top: true
                left: true
                right: true
            }

            height: 47

            L.RowLayout {
                id: mainLayout
                L.Layout.alignment: Qt.AlignTop
                width: parent.width
                implicitHeight: 25
                anchors.margins: 6
                spacing: 6

                // Left side - Workspaces
                WorkspaceWidget {
                    id: workspaces
                    implicitHeight: 30
                    L.Layout.alignment: Qt.AlignLeft

                    color: F.Colors.transparentize(F.Colors.backgroundColor, 0.2)
                    border.color: F.Colors.borderColor
                    border.width: 2
                    radius: 10
                }

                TrayWidget {
                    id: tray
                    implicitHeight: 30
                    L.Layout.alignment: Qt.AlignLeft

                    color: F.Colors.transparentize(F.Colors.backgroundColor, 0.2)
                    border.color: F.Colors.borderColor
                    border.width: 2
                    radius: 10
                }

                // Center - Taskbar
                TaskbarWidget {
                    id: taskbar
                    L.Layout.fillWidth: true
                    implicitHeight: 30

                    color: F.Colors.transparentize(F.Colors.backgroundColor, 0.2)
                    border.color: F.Colors.borderColor
                    border.width: 2
                    radius: 10
                }

                // Right side - System info
                Rectangle {
                    id: rightPanel
                    implicitWidth: rightLayout.implicitWidth + 20
                    implicitHeight: 30

                    color: F.Colors.transparentize(F.Colors.backgroundColor, 0.2)
                    border.color: F.Colors.borderColor
                    border.width: 2
                    radius: 10

                    // Option 1: Use Layout properties in your RowLayout
                    L.RowLayout {
                        id: rightLayout
                        anchors.centerIn: parent
                        implicitWidth: 700
                        spacing: 12

                        VolumeWidget {
                            volume: S.Audio.volume
                            L.Layout.fillHeight: true
                            L.Layout.preferredWidth: implicitWidth
                        }

                        MemoryWidget {
                            usedMemory: S.Memory.memoryUsed
                            totalMemory: "31.4Gi"
                            L.Layout.fillHeight: true
                            L.Layout.preferredWidth: implicitWidth
                        }

                        ClockWidget {
                            time: S.Time.datetime
                            L.Layout.fillHeight: true
                            L.Layout.preferredWidth: implicitWidth
                        }
                    }
                }
            }
        }
    }
}
