// Bar.qml
pragma ComponentBehavior: Bound
import Quickshell
import QtQuick

import QtQuick.Layouts as L
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

                L.ColumnLayout {
                    id: mainLayout
                    L.Layout.alignment: Qt.AlignLeft
                    height: parent.height
                    implicitWidth: parent.width

                    WorkspaceWidget {
                        id: workspaces

                        L.Layout.fillWidth: true
                        L.Layout.alignment: Qt.AlignTop
                        color: "transparent"
                    }

                    Rectangle {
                        id: widgets
                        implicitWidth: window.width
                        implicitHeight: widgetLayout.implicitHeight + 16  // Add padding
                        color: "transparent"
                        border.color: F.Colors.borderColor
                        border.width: 1
                        radius: 8

                        L.ColumnLayout {
                            id: widgetLayout
                            anchors.fill: parent
                            anchors.margins: 8
                            spacing: 5

                            ClockWidget {
                                L.Layout.fillWidth: true
                                L.Layout.alignment: Qt.AlignHCenter
                            }

                            VolumeWidget {
                                L.Layout.fillWidth: true
                                L.Layout.alignment: Qt.AlignHCenter
                                L.Layout.preferredHeight: implicitHeight || 20
                            }

                            // Add more widgets here as needed
                        }
                    }

                    TrayWidget {
                        id: tray

                        implicitWidth: parent.width
                        L.Layout.fillWidth: true
                        L.Layout.alignment: Qt.AlignBottom
                        color: "transparent"
                    }
                }
            }
        }
    }
}
