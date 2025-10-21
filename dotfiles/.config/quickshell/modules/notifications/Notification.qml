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
    required property bool expandText

    implicitHeight: expandText ? layout.height + Config.layout.ratios[0] * Config.layout.spacing : layout.height
    implicitWidth: layout.width

    Layout.rightMargin: 15

    Rectangle {
        id: layout
        implicitWidth: Config.notifs.width
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

                function truncateTitle(fontSisze: int, text: string, boxWidth = contentLayout.width): string {
                    const maxLength = parseInt(boxWidth / fontSisze);

                    if (text.length < maxLength)
                        return text;
                    else {
                        return text.substr(0, maxLength) + "...";
                    }
                }

                RowLayout {
                    Layout.maximumWidth: contentLayout.width

                    Text {
                        Layout.alignment: Qt.AlignLeft
                        text: contentLayout.truncateTitle(font.pixelSize / 1.5, root.modelData.summary)
                        elide: Text.ElideRight
                        wrapMode: Text.Wrap
                        maximumLineCount: 1
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
                    id: bodyText
                    Layout.fillWidth: true
                    elide: Text.ElideRight
                    wrapMode: Text.Wrap
                    font.weight: Font.Medium
                    maximumLineCount: root.expandText ? 5 : 1
                    text: root.expandText ? root.modelData.body : contentLayout.truncateTitle(font.pixelSize / 2, root.modelData.body)
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
