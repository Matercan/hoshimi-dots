import QtQuick

import qs.functions as F

Row {
    required property string volume
    property string activeColor: F.Colors.activeColor

    spacing: 8

    Rectangle {
        width: 26
        height: 26
        anchors.verticalCenter: parent.verticalCenter
        radius: 13
        color: parent.activeColor

        Text {
            id: volumeIcon
            text: "󰋋"
            color: F.Colors.iconColor
            font.family: "CaskaydiaCove Nerd Font"
            font.bold: true
            font.pixelSize: 15
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.verticalCenter: parent.verticalCenter
        }
    }

    Text {
        id: volumeValue
        text: parent.volume
        color: parent.activeColor
        font.family: "CaskaydiaCove Nerd Font"
        font.bold: true
        font.pixelSize: 15
        anchors.verticalCenter: parent.verticalCenter
    }
}
