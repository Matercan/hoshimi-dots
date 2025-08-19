import QtQuick

Text {
    required property string usage

    text: `<span style="color: #FF9F0A"> </span> ${usage}%`
    // Text styling
    color: "#f0d017"                    // White text
    font.family: "CaskaydiaCove Nerd Font"
    font.bold: true
    font.pixelSize: 15

    // Center the text
    horizontalAlignment: Text.AlignHCenter
    verticalAlignment: Text.AlignVCenter
}
