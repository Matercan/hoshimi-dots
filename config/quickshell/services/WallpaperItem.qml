import Quickshell
import qs.generics

import Quickshell
import Quickshell.Wayland

Variants {
    model: Quickshell.screens

    PanelWindow {
        id: w
        WlrLayershell.namespace: "wallpaper"

        required property var modelData
        screen: modelData

        anchors {
            right: true
            left: true
            bottom: true
            top: true
        }

        exclusionMode: ExclusionMode.Ignore
        WlrLayershell.layer: WlrLayer.Background
        Wallpaper {}
    }
}
