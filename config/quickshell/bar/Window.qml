pragma ComponentBehavior: Bound
import QtQuick
import QtQuick.Layouts

import qs.sources
import qs.functions as F

Rectangle {
    id: root
    implicitWidth: layout.width
    implicitHeight: layout.height
    color: "transparent"

    function truncateTitle(title, maxLength = Math.floor(root.height / 9)) {
        if (title.length <= maxLength) {
            return title;
        }
        return title.substring(0, maxLength - 3) + "...";
    }

    ColumnLayout {
        id: layout
        anchors.centerIn: parent

        ColumnLayout {
            Layout.fillHeight: true
            Layout.fillWidth: true
            Layout.alignment: Qt.AlignCenter
            spacing: -6

            Repeater {
                model: {
                    if (Desktop.activeWindow.title == null)
                        return "Admiring the Desktop";
                    else if (Desktop.activeWindow.title.length >= root.height / 9) {
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
