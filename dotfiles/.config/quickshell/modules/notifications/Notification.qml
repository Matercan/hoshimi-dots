import qs.globals
import qs.functions

import Quickshell.Services.Notifications
import Quickshell.Widgets
import QtQuick
import QtQuick.Layouts

import QtQuick

Item {
    id: root
    required property var modelData
    implicitHeight: layout.height
    implicitWidth: layout.width

    Layout.rightMargin: 15

    MouseArea {
        id: area
        anchors.fill: parent
        hoverEnabled: true
        cursorShape: Qt.WhatsThisCursor
    }

    Rectangle {
        id: layout
        implicitWidth: 360
        implicitHeight: mainLayout.height
        radius: 15
        anchors.centerIn: parent
        color: Colors.palette.m3background

        RowLayout {
            id: mainLayout

            spacing: Config.layout.spacing

            anchors.top: parent.top
            anchors.right: parent.right
            anchors.left: parent.left

            implicitWidth: parent.width

            Item {
                id: coverItem

                visible: root.modelData.image != ""

                Layout.alignment: Qt.AlignTop
                implicitHeight: Config.icons.mediumSize
                implicitWidth: Config.icons.mediumSize
                Layout.margins: Config.layout.padding * 3 / 2
                Layout.rightMargin: 0

                ClippingWrapperRectangle {
                    visible: true

                    color: "transparent"

                    anchors {
                        horizontalCenter: coverItem.right
                        verticalCenter: coverItem.bottom
                        horizontalCenterOffset: -2 * Config.layout.padding
                        verticalCenterOffset: -2 * Config.layout.padding
                    }

                    radius: 2

                    IconImage {
                        implicitSize: coverItem.height
                        source: root.modelData.image
                        smooth: true
                    }
                }
            }

            ColumnLayout {
                id: contentLayout

                Layout.fillWidth: true
                Layout.margins: Config.layout.padding * 3 / 2
                Layout.leftMargin: coverItem.visible ? Config.layout.padding / 2 : Config.layout.padding * 3 / 2
                spacing: Config.layout.spacing

                RowLayout {
                    Layout.maximumWidth: contentLayout.width

                    Text {
                        Layout.alignment: Qt.AlignLeft
                        text: root.modelData.summary
                        elide: Text.ElideRight
                        font.weight: Font.Bold
                        font.family: Variables.fontFamily
                        color: Colors.light ? Colors.palette.m3inverseOnSurface : Colors.palette.m3onSurface
                    }

                    Text {
                        Layout.alignment: Qt.AlignRight
                        text: root.modelData.timeStr
                        font.family: Variables.fontFamily
                        color: Colors.light ? Colors.palette.m3inverseOnSurface : Colors.palette.m3onSurface
                    }
                }

                Text {
                    id: boyText
                    Layout.fillWidth: true
                    elide: Text.ElideRight
                    wrapMode: Text.Wrap
                    font.weight: Font.Medium
                    maximumLineCount: 5
                    text: root.modelData.body
                    font.family: Variables.fontFamily
                    color: Colors.light ? Colors.palette.m3inverseOnSurface : Colors.palette.m3onSurface
                }

                RowLayout {
                    visible: root.modelData.actions.length > 1

                    Layout.fillWidth: true
                    implicitHeight: actionRepeater.height

                    Repeater {
                        id: actionRepeater
                        model: root.modelData.actions.slice(1)

                        Rectangle {
                            id: actionButtomMA
                            required property NotificationAction modelData
                            implicitHeight: actionButton.height

                            MouseArea {
                                id: mArea
                                anchors.fill: parent
                                hoverEnabled: true
                                onPressed: actionButtomMA.modelData.invoke()
                            }

                            Rectangle {
                                id: actionButton

                                radius: 16
                                color: mArea.containsMouse ? Colors.palette.m3secondary : Colors.palette.m3primary
                                implicitHeight: buttonText.height

                                Layout.fillWidth: true

                                Text {
                                    id: buttonText

                                    anchors.centerIn: parent
                                    text: actionButtomMA.modelData.text
                                }
                            }
                        }
                    }
                }
            }
        }
    }
}
