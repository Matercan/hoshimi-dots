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

                    Loader {
                        active: true
                        sourceComponent: WorkspaceWidget {
                            id: workspaces

                            Layout.fillWidth: true
                            Layout.alignment: Qt.AlignTop
                            color: "transparent"
                        }
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
                        Layout.alignment: Qt.AlignTop
                        Layout.fillHeight: true
                        Layout.leftMargin: 7

                        sourceComponent: Windows {

                            Layout.bottomMargin: 10
                            Layout.fillHeight: true
                        }
                    }

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
                            implicitWidth: 35
                            implicitHeight: widgetLayout.implicitHeight + 16  // Add padding
                            color: "transparent"
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
                                spacing: 5

                                Loader {
                                    active: true
                                    Layout.fillWidth: true
                                    Layout.alignment: Qt.AlignHCenter

                                    sourceComponent: BatteryWidget {
                                        Layout.fillWidth: true
                                        Layout.alignment: Qt.AlignHCenter
                                    }
                                }

                                ClockWidget {
                                    barY: widgets.y
                                    Layout.fillWidth: true
                                    Layout.alignment: Qt.AlignHCenter
                                }

                                Loader {
                                    active: true
                                    Layout.fillWidth: true
                                    Layout.alignment: Qt.AlignHCenter
                                    sourceComponent: VolumeWidget {
                                        Layout.fillWidth: true
                                        Layout.alignment: Qt.AlignHCenter
                                        Layout.preferredHeight: implicitHeight || 20
                                    }
                                }
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
