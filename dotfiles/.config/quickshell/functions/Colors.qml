// Managed by Hoshimi

pragma Singleton

import Quickshell
import QtQuick

Singleton {
    id: root

    // Colors used throuhgout the configuration
    property string backgroundColor: "#1e1e1e"
    property string foregroundColor: "#cdd6d6"

    property string paletteColor1: "#454747"
    property string paletteColor2: "#f38b8b"
    property string paletteColor3: "#a6e3e3"
    property string paletteColor4: "#f9e2e2"
    property string paletteColor5: "#89b4b4"
    property string paletteColor6: "#f5c2c2"
    property string paletteColor7: "#94e2e2"
    property string paletteColor8: "#a6adad"
    property string paletteColor9: "#585b5b"
    property string paletteColor10: "#f38b8b"
    property string paletteColor11: "#a6e3e3"
    property string paletteColor12: "#f9e2e2"
    property string paletteColor13: "#89b4b4"
    property string paletteColor14: "#f5c2c2"
    property string paletteColor15: "#94e2e2"
    property string paletteColor16: "#bac2c2"

    property string activeColor: paletteColor5
    property string selectedColor: paletteColor3
    property string iconColor: paletteColor13
    property string errorColor: paletteColor2
    property string passwordColor: paletteColor4
    property string borderColor: paletteColor7

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

    /**
     * Gets the palette color of a specified string
     *
     * @param {string} color - The color e.g. blue, red, white
     * @return {Qt.color} The resulting color from the palette
     */
    function getPaletteColor(colorName: string): string {
        switch (colorName) {
        case "black":
            return paletteColor1;
        case "maroon":
            return paletteColor2;
        case "green":
            return paletteColor3;
        case "olive":
            return paletteColor4;
        case "navy":
            return paletteColor5;
        case "purple":
            return paletteColor6;
        case "teal":
            return paletteColor7;
        case "silver":
            return paletteColor8;
        case "grey":
            return paletteColor9;
        case "red":
            return paletteColor10;
        case "lime":
            return paletteColor11;
        case "yellow":
            return paletteColor12;
        case "blue":
            return paletteColor13;
        case "fuchsia":
            return paletteColor14;
        case "aqua":
            return paletteColor15;
        case "white":
            return paletteColor16;
        default:
            return "#ff0000";
        }
    }

    /**
     * Interpelates between 2 colors depending on a percentage
     *
     * @param {string} color A - The starting color (Any Qt.Color)
     * @param [string] color B - The end color (Any Qt.Color)
     * @param {number} percentage - The percent B vs A
     * @return {Qt.rba} The resulting color
     */
    function interpolate(colorA, colorB, percentage: real) {
        var a = Qt.color(colorA);
        var b = Qt.color(colorB);

        var rTrack = (a.r * (1 - percentage) + b.r * percentage);
        var gTrack = (a.g * (1 - percentage) + b.g * percentage);
        var bTrack = (a.b * (1 - percentage) + b.b * percentage);

        return Qt.rgba(rTrack, gTrack, bTrack, 1);
    }
}
