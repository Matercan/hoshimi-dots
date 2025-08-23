// Bar.qml
pragma ComponentBehavior: Bound
import Quickshell
import QtQuick
import QtQuick.Layouts as L
import qs.functions as F
import qs.sources as S

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

            implicitHeight: 30

            L.RowLayout {
                id: mainLayout
                L.Layout.alignment: Qt.AlignTop
                width: parent.width
                implicitHeight: 25
                anchors.margins: 0
                spacing: 0

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
                    L.Layout.alignment: Qt.AlignRight

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
