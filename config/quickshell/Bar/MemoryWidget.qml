import QtQuick

Text {
    id: memoryText
    required property string usedMemory
    required property string totalMemory
    color: "#ff8080"
    text: " " + usedMemory + "/" + totalMemory

    font.family: "CaskaydiaCove Nerd Font"
    font.bold: true
    font.pixelSize: 15

    // Center the text
    horizontalAlignment: Text.AlignHCenter
    verticalAlignment: Text.AlignVCenter
}
