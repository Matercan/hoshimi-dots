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
    property string activeColor: "#d20f39"
    property string selectedColor: "#4c4f69"
    property string iconColor: "#f9e2af"
    property string errorColor: "#A0001E"
    property string passwordColor: "#191970"
}
