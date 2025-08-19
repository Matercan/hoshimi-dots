import QtQuick

Text {
    required property string volume

    text: " " + volume

    // Text styling
    color: "#0000ff"                    // White text
    font.family: "CaskaydiaCove Nerd Font"
    font.bold: true
    font.pixelSize: 15

    // Center the text
    horizontalAlignment: Text.AlignHCenter
    verticalAlignment: Text.AlignVCenter
}
