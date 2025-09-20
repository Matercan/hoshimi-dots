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

                    Text {
                        Layout.margins: 5
                        text: ""
                        font.family: G.Variables.fontFamily
                        Layout.alignment: Qt.AlignCenter
                        color: F.Colors.foregroundColor
                    }

                    Loader {
                        active: true
                        sourceComponent: WorkspaceWidget {
                            id: workspaces

                            Layout.fillWidth: true
                            Layout.alignment: Qt.AlignTop
                            color: "transparent"
                        }
                        Layout.fillHeight: true
                        Layout.alignment: Qt.AlignTop
                    }

                    /* Loader {
                        asyncrhonous: true
                        Window {

                            id: spacer

                            implicitHeight: 200
                            Layout.alignment: Qt.AlignHCenter
                        }
                    } */

                    Loader {
                        active: true
                        Layout.fillWidth: true
                        Layout.alignment: Qt.AlignBottom

                        sourceComponent: Cava {
                            id: cava
                            barY: y

                            Layout.fillWidth: true
                            Layout.alignment: Qt.AlignBottom
                            implicitHeight: 75
                        }
                    }

                    TrayWidget {
                        id: tray
                        rectY: y

                        implicitWidth: parent.width
                        Layout.fillWidth: true
                        Layout.alignment: Qt.AlignBottom
                        color: "transparent"
                    }

                    Loader {
                        active: true
                        Layout.alignment: Qt.AlignBottom

                        sourceComponent: Rectangle {
                            id: widgets
                            implicitWidth: G.Variables.barSize
                            implicitHeight: widgetLayout.implicitHeight + 16  // Add padding
                            color: F.Colors.getPaletteColor("black")
                            border.color: F.Colors.borderColor
                            border.width: 1
                            radius: 8
                            Layout.fillWidth: true
                            Layout.alignment: Qt.AlignBottom
                            Layout.leftMargin: 1

                            ColumnLayout {
                                id: widgetLayout
                                anchors.fill: parent
                                anchors.margins: 8
                                spacing: 4

                                Loader {
                                    active: true
                                    Layout.fillWidth: true
                                    Layout.alignment: Qt.AlignHCenter
                                    Layout.preferredHeight: width

                                    sourceComponent: SystemStatus {
                                        id: status
                                        anchors.centerIn: parent
                                        topLevel: window
                                        widgetLayoutY: widgets.parent.y + widgetLayout.anchors.margins
                                    }
                                }
                                Loader {
                                    active: true
                                    Layout.fillWidth: true
                                    Layout.alignment: Qt.AlignHCenter
                                    Layout.preferredHeight: width

                                    sourceComponent: Volume {
                                        id: volume
                                        anchors.centerIn: parent
                                        topLevel: window
                                    }
                                }
                                Loader {
                                    active: true
                                    Layout.fillWidth: true
                                    Layout.alignment: Qt.AlignHCenter
                                }
                                Loader {
                                    active: true
                                    Layout.fillWidth: true
                                    Layout.alignment: Qt.AlignHCenter
                                }
                                Loader {
                                    active: true
                                    Layout.fillWidth: true
                                    Layout.alignment: Qt.AlignHCenter
                                }
                            }
                        }
                    }
                }
            }
        }
    }
}
