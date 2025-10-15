import QtQuick
import QtQuick.Layouts
import Quickshell

import qs.functions as F
import qs.services
import qs.globals

AnimatedImage {
    source: Variables.wallpaper
    antialiasing: false
    asynchronous: true

    width: Quickshell.screens[0].width * Config.layout.ratios[0]
    height: Quickshell.screens[0].height * Config.layout.ratios[0]

    anchors.bottom: parent.bottom
    anchors.right: parent.right
    mipmap: true
    retainWhileLoading: true
    cache: false
    smooth: true
}
