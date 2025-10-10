// Bar.qml
pragma ComponentBehavior: Bound
import Quickshell
import QtQuick
import QtQuick.Layouts
import QtMultimedia

import qs.functions
import qs.globals

Scope {
    id: root

    SoundEffect {
        id: sfx
        source: {
            return Variables.osuDirectory + "/start.wav";
        }
        onLoadedChanged: play()
    }

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
            implicitWidth: Config.bar.barSize

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
                        Layout.margins: Config.layout.padding
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
                            implicitWidth: Config.bar.barSize
                            implicitHeight: widgetLayout.implicitHeight + 2 * Config.layout.padding
                            color: "transparent"
                            radius: Config.layout.radius
                            Layout.fillWidth: true
                            Layout.alignment: Qt.AlignBottom
                            Layout.leftMargin: 1

                            ColumnLayout {
                                id: widgetLayout
                                anchors.fill: parent
                                anchors.margins: Config.layout.padding
                                spacing: Config.layout.spacing

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
