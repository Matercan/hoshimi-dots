// Bar.qml
pragma ComponentBehavior: Bound
import Quickshell
import QtQuick
import QtQuick.Layouts as L

Scope {
    Time {
        id: timeSource
    }
    Cpu {
        id: cpuSource
    }
    Memory {
        id: memorySource
    }
    Audio {
        id: volumeSource
    }

    Variants {
        model: Quickshell.screens

        PanelWindow {
            id: window
            property string backgroundColor: "#fbf1c7"
            property string foregroundColor: "#654735"
            property string borderColor: "#654735"
            property string activeColor: "#c14a4a"
            property string selectedColor: "#654735"

            required property var modelData
            screen: modelData

            color: "transparent"

            anchors {
                top: true
                left: true
                right: true
            }

            height: 42 // Fixed height instead of implicit

            L.RowLayout {
                id: mainLayout
                anchors.fill: parent
                anchors.margins: 6
                spacing: 6

                // Left side - Workspaces
                WorkspaceWidget {
                    id: workspaces
                    implicitHeight: 30
                    L.Layout.alignment: Qt.AlignLeft

                    color: window.backgroundColor
                    border.color: window.borderColor
                    border.width: 2
                    radius: 10
                }

                // Center - Taskbar
                TaskbarWidget {
                    id: taskbar
                    L.Layout.fillWidth: true
                    implicitHeight: 30

                    color: window.backgroundColor
                    border.color: window.borderColor
                    border.width: 2
                    radius: 10
                }

                // Right side - System info
                Rectangle {
                    id: rightPanel
                    implicitWidth: rightLayout.implicitWidth + 20
                    implicitHeight: 30

                    color: window.backgroundColor
                    border.color: window.borderColor
                    border.width: 2
                    radius: 10

                    L.RowLayout {
                        id: rightLayout
                        anchors.centerIn: parent
                        spacing: 15

                        VolumeWidget {
                            volume: volumeSource.volume
                        }

                        CpuWidget {
                            usage: cpuSource.cpuUsage
                        }

                        MemoryWidget {
                            usedMemory: memorySource.memoryUsed
                            totalMemory: "31.4Gi"
                        }

                        ClockWidget {
                            time: timeSource.time
                        }
                    }
                }
            }
        }
    }
}
