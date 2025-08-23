import QtQuick

import qs.functions as F

Row {
    required property string time
    property string activeColor: F.Colors.activeColor

    spacing: 8

    Rectangle {
        radius: 13
        height: 26
        width: 26
        anchors.verticalCenter: parent.verticalCenter
        color: parent.activeColor

        Text {
            id: clockIcon
            text: ""
            color: F.Colors.iconColor
            font.family: "CaskaydiaCove Nerd Font"
            font.bold: true
            font.pixelSize: 15
            anchors.verticalCenter: parent.verticalCenter
            anchors.horizontalCenter: parent.horizontalCenter
        }
    }

    Text {
        id: timeValue
        text: parent.time
        color: parent.activeColor
        font.family: "CaskaydiaCove Nerd Font"
        font.bold: true
        font.pixelSize: 15
        anchors.verticalCenter: parent.verticalCenter
    }
}
