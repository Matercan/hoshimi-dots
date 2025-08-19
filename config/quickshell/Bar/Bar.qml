// Bar.qml
pragma ComponentBehavior: Bound
import Quickshell
import QtQuick

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
            property string backgroundColor: "#000000"
            property string foregroundColor: "#ffffff"
            property string borderColor: foregroundColor
            property string activeColor: "#1ae8c9"
            property string selectedColor: "#490e14"

            required property var modelData
            screen: modelData

            color: "transparent"

            anchors {
                top: true
                left: true
                right: true
            }

            implicitHeight: container.implicitHeight
            implicitWidth: container.implicitWidth

            Item {
                id: container

                property real margin: 5

                implicitWidth: 1080
                implicitHeight: right.implicitHeight + margin * 2

                // Right side of the bar
                Rectangle {
                    id: right

                    property real margin: 20

                    width: 540
                    height: parent.height - parent.margin * 2
                    x: window.width - parent.margin - width
                    y: parent.margin

                    implicitWidth: 540

                    // Background styling
                    color: window.backgroundColor          // Black background
                    border.color: window.borderColor    // White border
                    border.width: 2
                    radius: 10   // Rounded corners
                    implicitHeight: 30 + border.width  // Increased height for better appearance

                    CpuWidget {
                        id: cpu
                        x: volume.x + parent.margin + volume.width
                        y: parent.height / 4

                        usage: cpuSource.cpuUsage
                    }
                    VolumeWidget {
                        id: volume

                        x: parent.margin
                        y: cpu.y - parent.height / 3.25
                        volume: volumeSource.volume
                    }
                    MemoryWidget {
                        id: memory
                        x: cpu.x + parent.margin + cpu.width
                        y: parent.height / 4

                        usedMemory: memorySource.memoryUsed
                        totalMemory: "31.4Gi"
                    }
                    ClockWidget {
                        id: clock
                        x: memory.x + parent.margin + memory.width
                        y: parent.height / 4

                        time: timeSource.time
                    }
                }
                WorkspaceWidget {
                    id: workspaces
                    x: parent.margin
                    y: parent.margin
                    height: parent.height - parent.margin * 2

                    color: window.backgroundColor

                    border.color: window.borderColor
                    border.width: 2
                    radius: 10
                }

                TaskbarWidget {
                    id: taskbar
                    y: parent.margin
                    x: parent.implicitWidth / 2
                    height: parent.height - parent.margin * 2

                    color: window.backgroundColor

                    border.color: window.borderColor
                    border.width: 2
                    radius: 10
                }
            }
        }
    }
}
