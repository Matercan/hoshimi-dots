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

    function truncateTitle(title, maxLength = Math.floor(root.height / 7)) {
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
                    var properTitle = Desktop.activeWindow.title;
                    if (properTitle[0] == '(') {
                        properTitle = F.Desktop.removeNotifications(properTitle);
                        console.log(properTitle);
                    }
                    if (properTitle == null)
                        return "Admiring the Desktop";
                    else if (properTitle.length >= root.height / 7) {
                        return root.truncateTitle(properTitle);
                    } else {
                        return properTitle;
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
