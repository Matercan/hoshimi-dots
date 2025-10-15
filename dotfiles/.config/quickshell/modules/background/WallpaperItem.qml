import Quickshell
import qs.generics
import qs.globals

import QtQuick
import Quickshell
import Quickshell.Wayland

Variants {
    model: Quickshell.screens

    PanelWindow {
        id: w
        WlrLayershell.namespace: "quickshell:wallpaper"
        WlrLayershell.layer: WlrLayer.Background

        required property var modelData
        screen: modelData

        // Position
        anchors {
            right: true
            left: true
            bottom: true
            top: true
        }

        Wallpaper {

            Clock {
                spacing: 2
                x: Config.background.clock.x
                y: Config.background.clock.y
            }
        }
    }
}
