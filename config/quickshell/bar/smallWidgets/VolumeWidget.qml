import QtQuick
import Quickshell
import Quickshell.Io
import Quickshell.Wayland

import qs.functions as F
import qs.sources as S
import qs.generics as G
import qs.globals as Glo

MouseArea {
    id: volumeWidget

    property bool showPopup
    required property int barY

    // Set proper dimensions
    implicitWidth: volumeText.implicitWidth + 8  // Add some padding
    implicitHeight: volumeText.implicitHeight + 4

    // Make it fill the available width from the layout
    width: implicitWidth
    height: 15

    Text {
        id: volumeText
        anchors.centerIn: parent  // This is the key fix!

        color: F.Colors.foregroundColor  // Add proper color
        font.pixelSize: 12

        text: {
            if (S.Audio.volume >= 66) {
                return "🔊";
            } else if (S.Audio.volume >= 33) {
                return "🔉";
            } else if (S.Audio.volume != 0) {
                return "🔉";
            } else {
                return "🔇";
            }
        }
    }

    hoverEnabled: true
    onClicked: openControl.running = true
    onEntered: {
        showPopup = true;
        popup.varShow = true;
        autoCloseTimer.restart();
    }

    Process {
        id: openControl
        command: ["pavucontrol"]
        running: false
    }

    Timer {
        id: autoCloseTimer
        running: false
        repeat: false
        interval: Glo.Variables.popupMenuOpenTime

        onTriggered: popup.varShow = false
    }

    Timer {
        id: closeTimer
        running: false
        repeat: false
        interval: 500

        onTriggered: {
            volumeWidget.showPopup = false;
        }
    }

    PanelWindow {
        id: popup
        property bool varShow
        property bool fullyOpen: false
        visible: volumeWidget.showPopup
        WlrLayershell.layer: WlrLayer.Top
        exclusionMode: ExclusionMode.Ignore

        MouseArea {
            implicitHeight: parent.height + 50
            implicitWidth: parent.width + 50
            anchors.verticalCenter: parent.verticalCenter
            anchors.horizontalCenter: parent.left
            hoverEnabled: true

            onExited: {
                popup.varShow = false;
                closeTimer.restart();
            }
        }

        anchors {
            left: true
            top: true
        }

        margins {
            left: Glo.Variables.barSize
            top: volumeWidget.barY
        }

        color: "transparent"

        implicitWidth: rect.width + 50
        implicitHeight: rect.height + 50

        G.PopupBox {
            id: rect
            root: popup
            fullyOpen: popup.fullyOpen
            varShow: popup.varShow
            radius: 10
            implicitWidth: textDisplay.width + 10
            implicitHeight: textDisplay.height + 10

            Text {
                id: textDisplay
                visible: !rect.closedAnimRunning
                anchors.centerIn: parent
                text: "Volume: " + S.Audio.volume
                color: F.Colors.foregroundColor
                font.family: Glo.Variables.fontFamily
            }
        }
    }
}
