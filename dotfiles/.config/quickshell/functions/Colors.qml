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

    component M3Palette: QtObject {
        property color m3primary_paletteKeyColor: "#a26387"
        property color m3secondary_paletteKeyColor: "#8b6f7d"
        property color m3tertiary_paletteKeyColor: "#9c6c53"
        property color m3neutral_paletteKeyColor: "#7f7478"
        property color m3neutral_variant_paletteKeyColor: "#827379"
        property color m3background: "#181115"
        property color m3onBackground: "#eddfe4"
        property color m3surface: "#181115"
        property color m3surfaceDim: "#181115"
        property color m3surfaceBright: "#40373b"
        property color m3surfaceContainerLowest: "#130c10"
        property color m3surfaceContainerLow: "#211a1d"
        property color m3surfaceContainer: "#251e21"
        property color m3surfaceContainerHigh: "#30282b"
        property color m3surfaceContainerHighest: "#3b3236"
        property color m3onSurface: "#eddfe4"
        property color m3surfaceVariant: "#504349"
        property color m3onSurfaceVariant: "#d3c2c9"
        property color m3inverseSurface: "#eddfe4"
        property color m3inverseOnSurface: "#362e32"
        property color m3outline: "#9c8d93"
        property color m3outlineVariant: "#504349"
        property color m3shadow: "#000000"
        property color m3scrim: "#000000"
        property color m3surfaceTint: "#fbb1d8"
        property color m3primary: "#fbb1d8"
        property color m3onPrimary: "#511d3e"
        property color m3primaryContainer: "#6b3455"
        property color m3onPrimaryContainer: "#ffd8ea"
        property color m3inversePrimary: "#864b6e"
        property color m3secondary: "#dfbecd"
        property color m3onSecondary: "#402a36"
        property color m3secondaryContainer: "#5a424f"
        property color m3onSecondaryContainer: "#fcd9e9"
        property color m3tertiary: "#f3ba9c"
        property color m3onTertiary: "#4a2713"
        property color m3tertiaryContainer: "#b8856a"
        property color m3onTertiaryContainer: "#000000"
        property color m3error: "#ffb4ab"
        property color m3onError: "#690005"
        property color m3errorContainer: "#93000a"
        property color m3onErrorContainer: "#ffdad6"
        property color m3primaryFixed: "#ffd8ea"
        property color m3primaryFixedDim: "#fbb1d8"
        property color m3onPrimaryFixed: "#370728"
        property color m3onPrimaryFixedVariant: "#6b3455"
        property color m3secondaryFixed: "#fcd9e9"
        property color m3secondaryFixedDim: "#dfbecd"
        property color m3onSecondaryFixed: "#291520"
        property color m3onSecondaryFixedVariant: "#58404c"
        property color m3tertiaryFixed: "#ffdbca"
        property color m3tertiaryFixedDim: "#f3ba9c"
        property color m3onTertiaryFixed: "#311302"
        property color m3onTertiaryFixedVariant: "#653d27"
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
