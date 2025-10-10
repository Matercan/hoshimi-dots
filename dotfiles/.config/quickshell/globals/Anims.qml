pragma Singleton

import qs.globals
import Quickshell
import QtQuick

Singleton {
    component ExpAnim: NumberAnimation {
        duration: MaterialEasing.expressiveEffectsTime
        easing.type: Easing.Bezier
        easing.bezierCurve: MaterialEasing.expressiveEffects
    }

    component EmphAnim: NumberAnimation {
        duration: MaterialEasing.emphasizedTime
        easing.type: Easing.Bezier
        easing.bezierCurve: MaterialEasing.emphasized
    }

    component Anim: NumberAnimation {
        duration: MaterialEasing.standardTime
        easing.type: Easing.Bezier
        easing.bezierCurve: MaterialEasing.standard
    }
}
