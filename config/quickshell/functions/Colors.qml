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
    property string backgroundColor: "#1e1e2e"
    property string foregroundColor: "#cdd6f4"
    property string borderColor: "#cdd6f4"
    property string activeColor: "#f38ba8"
    property string selectedColor: "#cdd6f4"
    property string iconColor: "#f9e2af"
}
