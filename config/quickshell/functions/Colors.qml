pragma Singleton

import Quickshell

Singleton {

    /**
    * Transparentizes a color by a given percentage.
    *
    * @param {string} color - The color (any Qt.color-compatible string).
    * @param {number} percentage - The amount to transparentize (0-1).
    * @returns {Qt.rgba} The resulting color.
    */
    function transparentize(color, percentage = 1) {
        var c = Qt.color(color);
        return Qt.rgba(c.r, c.g, c.b, c.a * (1 - percentage));
    }

    // Colors used throuhgout the configuration
    property string backgroundColor: "#eff1f5"
    property string foregroundColor: "#4c4f69"
    property string borderColor: "#4c4f69"

    property string paletteColor1: "#5c5f77"
    property string paletteColor2: "#d20f39"
    property string paletteColor3: "#40a02b"
    property string paletteColor4: "#df8e1d"
    property string paletteColor5: "#1e66f5"
    property string paletteColor6: "#ea76cb"
    property string paletteColor7: "#179299"
    property string paletteColor8: "#acb0be"
    property string paletteColor9: "#6c6f85"
    property string paletteColor10: "#d20f39"
    property string paletteColor11: "#40a02b"
    property string paletteColor12: "#df8e1d"
    property string paletteColor13: "#1e66f5"
    property string paletteColor14: "#ea76cb"
    property string paletteColor15: "#179299"
    property string paletteColor16: "#bcc0cc"

    property string activeColor: paletteColor5
    property string selectedColor: paletteColor3
    property string iconColor: paletteColor13
    property string errorColor: paletteColor1
    property string passwordColor: paletteColor4
}
