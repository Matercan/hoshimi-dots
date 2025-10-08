// Bar.qml
pragma ComponentBehavior: Bound
import Quickshell
import QtQuick
import QtQuick.Layouts

import qs.bar

import qs.functions
import qs.globals

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
            implicitWidth: Variables.barSize

            Rectangle {
                color: Colors.palette.m3background
                implicitHeight: parent.height
                implicitWidth: parent.width

                ColumnLayout {
                    id: mainyout
                    Layout.alignment: Qt.AlignLeft
                    height: parent.height
                    implicitWidth: parent.width

                    Text {
                        Layout.margins: Config.padding
                        text: ""
                        font.family: Variables.fontFamily
                        Layout.alignment: Qt.AlignCenter
                        color: Colors.palette.m3onBackground
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
                            implicitWidth: Variables.barSize
                            implicitHeight: widgetLayout.implicitHeight + 2 * Config.padding  // Add padding
                            color: "transparent"
                            radius: Config.radius
                            Layout.fillWidth: true
                            Layout.alignment: Qt.AlignBottom
                            Layout.leftMargin: 1

                            ColumnLayout {
                                id: widgetLayout
                                anchors.fill: parent
                                anchors.margins: Config.padding
                                spacing: Config.spacing

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
