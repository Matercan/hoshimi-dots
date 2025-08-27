pragma ComponentBehavior: Bound
import Quickshell
import Quickshell.Io
import QtQuick
import QtQuick.Layouts

import qs.sources
import qs.functions as F

Rectangle {
    id: root
    implicitWidth: layout.width
    implicitHeight: layout.height
    color: "transparent"

    function truncateTitle(title, maxLength = Math.floor(root.height / 12)) {
        if (title.length <= maxLength) {
            return title;
        }
        return title.substring(0, maxLength - 3) + "...";
    }

    ColumnLayout {
        id: layout
        anchors.centerIn: parent
        Rectangle {
            Layout.alignment: Qt.AlignCenter
            Layout.fillWidth: true
            Layout.rightMargin: 2
            implicitWidth: icon.width + 10
            implicitHeight: icon.height + 10
            radius: implicitWidth / 2
            color: F.Colors.transparentize(F.Colors.getPaletteColor("light pink"), 0.5)

            Text {
                id: icon
                anchors.centerIn: parent
                color: F.Colors.activeColor
                font.pixelSize: 12
                font.family: "Shadow Whisper"
                text: Desktop.activeWindow.title == null ? "" : F.Desktop.getWindowIcon(Desktop.activeWindow.class)
            }
        }
        ColumnLayout {
            Layout.fillHeight: true
            Layout.fillWidth: true
            Layout.alignment: Qt.AlignCenter
            spacing: -6

            Repeater {
                model: {
                    if (Desktop.activeWindow.title == null)
                        return "Admiring the Desktop";
                    else if (Desktop.activeWindow.title.length >= root.height / 12) {
                        return root.truncateTitle(Desktop.activeWindow.title);
                    } else {
                        return Desktop.activeWindow.title;
                    }
                }
                delegate: Text {
                    required property var modelData
                    text: modelData
                    color: F.Colors.activeColor
                    rotation: 90
                    font.pixelSize: 12
                    font.family: "Shadow Whisper"
                }
            }
        }
    }
}
