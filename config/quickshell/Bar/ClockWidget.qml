import QtQuick

Text {
    required property string time

    text: " " + time

    // Text styling
    color: "#000fff"                    // White text
    font.family: "CaskaydiaCove Nerd Font"
    font.bold: true
    font.pixelSize: 15

    // Center the text
    horizontalAlignment: Text.AlignHCenter
    verticalAlignment: Text.AlignVCenter
}
