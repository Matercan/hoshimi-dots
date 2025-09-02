import qs.sources as S
import qs.functions

import QtQuick
import QtQuick.Layouts

import QtQuick

Rectangle {
    id: root
    required property var modelData
    implicitHeight: layout.height
    implicitWidth: layout.width
    readonly property date time: new Date()
    readonly property real now: time.getTime()
    color: Colors.transparentize(Colors.getPaletteColor("teal"), 0.5)
    Layout.rightMargin: 15
    radius: 16

    NumberAnimation on y {
        easing.type: Easing.Bezier
    }

    ColumnLayout {
        id: layout
        Rectangle {
            id: countDown

            radius: 5
            color: Colors.getPaletteColor("blue")
            Layout.preferredHeight: 5
        }

        Timer {
            id: timer
            repeat: true
            running: true
            interval: 50
            onTriggered: {
                var timeNow = Time.dateStringToUnix(S.Time.datetime);
                var timeDiff = timeNow - root.modelData.time.getTime();
                countDown.implicitWidth = 300 * (5 - timeDiff / 1000) / 5;
            }
        }

        RowLayout {

            Rectangle {
                Layout.preferredWidth: 32
                Layout.preferredHeight: 32
                radius: 16
                color: Colors.getPaletteColor("teal")

                Image {
                    anchors.fill: parent
                    source: root.modelData.image || "/usr/share/icons/candy-icons/status/scalable/notification-active.svg"
                    anchors.margins: 5

                    sourceSize.width: parent.width - anchors.margins
                    sourceSize.height: parent.height - anchors.margins

                    mipmap: true
                    smooth: true
                }
            }

            ColumnLayout {
                id: textLayout
                spacing: 0

                function truncateText(text: string, pixelSize: real): string {
                    pixelSize /= 2;
                    if (text.length * pixelSize <= 300) {
                        return text;
                    }
                    var maxLength = 300 / pixelSize;
                    return text.substring(0, maxLength - 3) + "...";
                }

                RowLayout {
                    Layout.preferredWidth: 270
                    Text {
                        color: Colors.foregroundColor
                        Layout.alignment: Qt.AlignLeft
                        text: textLayout.truncateText(root.modelData.summary, 18) // one size bigger to account for time
                        font.pixelSize: 14
                        font.weight: Font.Bold
                    }
                    Rectangle {
                        Layout.preferredWidth: 3
                        Layout.alignment: Qt.AlignLeft
                        Layout.preferredHeight: 3
                        color: Colors.foregroundColor
                        radius: 1.5
                    }
                    Text {
                        Layout.leftMargin: 0
                        color: Colors.foregroundColor
                        text: root.modelData.timeStr
                        font.weight: Font.Thin
                        Layout.alignment: Qt.AlignLeft
                    }
                    Text {
                        color: Colors.foregroundColor
                        text: ""
                        font.weight: Font.Thin
                        Layout.alignment: Qt.AlignRight
                    }
                }

                Text {
                    color: Colors.foregroundColor
                    text: area.containsMouse ? root.modelData.body : textLayout.truncateText(root.modelData.body, 12)
                    wrapMode: Text.WordWrap
                    Layout.preferredWidth: 300
                    font.pixelSize: 12
                }
            }
        }
    }

    MouseArea {
        id: area
        anchors.fill: parent
        hoverEnabled: true
        cursorShape: Qt.WhatsThisCursor
    }
}
