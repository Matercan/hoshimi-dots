pragma ComponentBehavior: Bound
// Managed by Hoshimi

pragma Singleton

import Quickshell
import QtQuick

Singleton {
    id: root

    // Colors used throuhgout the configuration
    property string backgroundColor: "#1e1e2e"
    property string foregroundColor: "#cdd6f4"

    property string paletteColor1: "#45475a"
    property string paletteColor2: "#f38ba8"
    property string paletteColor3: "#a6e3a1"
    property string paletteColor4: "#f9e2af"
    property string paletteColor5: "#89b4fa"
    property string paletteColor6: "#f5c2e7"
    property string paletteColor7: "#94e2d5"
    property string paletteColor8: "#a6adc8"
    property string paletteColor9: "#585b70"
    property string paletteColor10: "#f38ba8"
    property string paletteColor11: "#a6e3a1"
    property string paletteColor12: "#f9e2af"
    property string paletteColor13: "#89b4fa"
    property string paletteColor14: "#f5c2e7"
    property string paletteColor15: "#94e2d5"
    property string paletteColor16: "#bac2de"

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

    function lighten(color, factor) {
        return interpolate(color, "#ffffff", factor);
    }

    function darken(color, factor) {
        return interpolate(color, "#000000", factor);
    }

    function desaturate(color, factor) {
        // Convert to HSV, reduce saturation
        let hsv = Qt.hsva(color.hsvHue, color.hsvSaturation * (1 - factor), color.hsvValue, color.a);
        return hsv;
    }

    function adjustAlpha(color, alpha) {
        return Qt.rgba(color.r, color.g, color.b, alpha);
    }

    function blend(baseColor, overlayColor, opacity) {
        return interpolate(baseColor, overlayColor, opacity);
    }

    /**
     * Interpelates between 2 colors depending on a percentage
     *
     * @param {string} color A - The starting color (Any Qt.Color)
     * @param [string] color B - The end color (Any Qt.Color)
     * @param {number} percentage - The percent B vs A
     * @return {Qt.rba} The resulting color
     */
    function interpolate(color1: color, color2: color, factor: real): color {
        // Your existing interpolation function
        let r1 = color1.r;
        let g1 = color1.g;
        let b1 = color1.b;

        let r2 = color2.r;
        let g2 = color2.g;
        let b2 = color2.b;

        let r = Math.round(r1 + (r2 - r1) * factor);
        let g = Math.round(g1 + (g2 - g1) * factor);
        let b = Math.round(b1 + (b2 - b1) * factor);

        return Qt.rgba(r, g, b, 1);
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

        // Key Colors main colors
        property color m3primary_paletteKeyColor: root.paletteColor6     // Use paletteColor5 as primary
        property color m3secondary_paletteKeyColor: root.paletteColor5       // Use blue as secondary
        property color m3tertiary_paletteKeyColor: root.paletteColor4      // Use yellow as tertiary
        property color m3neutral_paletteKeyColor: root.paletteColor8       // Use white/gray as neutral
        property color m3neutral_variant_paletteKeyColor: root.paletteColor9

        // Surface Colors (backgrounds)
        property color m3background: root.backgroundColor
        property color m3onBackground: root.paletteColor16
        property color m3surface: root.paletteColor1
        property color m3surfaceDim: root.paletteColor1
        property color m3surfaceBright: root.lighten(root.paletteColor9, 0.3)
        property color m3surfaceContainerLowest: root.darken(root.paletteColor1, 0.1)
        property color m3surfaceContainerLow: root.lighten(root.paletteColor1, 0.05)
        property color m3surfaceContainer: root.paletteColor9
        property color m3surfaceContainerHigh: root.lighten(root.paletteColor9, 0.15)
        property color m3surfaceContainerHighest: root.lighten(root.paletteColor9, 0.25)
        property color m3onSurface: root.paletteColor15
        property color m3surfaceVariant: root.blend(root.paletteColor1, root.paletteColor16, 0.15)
        property color m3onSurfaceVariant: root.lighten(root.paletteColor16, 0.2)

        // Inverse Colors
        property color m3inverseSurface: root.paletteColor16
        property color m3inverseOnSurface: root.darken(root.paletteColor1, 0.2)

        // Outline Colors
        property color m3outline: root.desaturate(root.paletteColor16, 0.4)
        property color m3outlineVariant: root.blend(root.paletteColor9, root.paletteColor16, 0.2)

        // Utility Colors
        property color m3shadow: root.paletteColor1
        property color m3scrim: root.paletteColor1
        property color m3surfaceTint: root.lighten(root.paletteColor6, 0.2)

        // Primary Colors
        property color m3primary: root.lighten(root.paletteColor6, 0.1)
        property color m3onPrimary: root.darken(root.paletteColor1, 0.1)
        property color m3primaryContainer: root.darken(root.paletteColor6, 0.3)
        property color m3onPrimaryContainer: root.lighten(root.paletteColor6, 0.4)
        property color m3inversePrimary: root.darken(root.paletteColor6, 0.2)

        // Secondary Colors
        property color m3secondary: root.lighten(root.paletteColor5, 0.2)
        property color m3onSecondary: root.darken(root.paletteColor1, 0.1)
        property color m3secondaryContainer: root.darken(root.paletteColor5, 0.3)
        property color m3onSecondaryContainer: root.lighten(root.paletteColor5, 0.4)

        // Tertiary Colors
        property color m3tertiary: root.lighten(root.paletteColor4, 0.1)
        property color m3onTertiary: root.darken(root.paletteColor1, 0.1)
        property color m3tertiaryContainer: root.darken(root.paletteColor4, 0.2)
        property color m3onTertiaryContainer: root.lighten(root.paletteColor4, 0.3)

        // Error Colors
        property color m3error: root.lighten(root.paletteColor2, 0.2)
        property color m3onError: root.darken(root.paletteColor1, 0.1)
        property color m3errorContainer: root.darken(root.paletteColor2, 0.4)
        property color m3onErrorContainer: root.lighten(root.paletteColor2, 0.4)

        // Fixed Colors
        property color m3primaryFixed: root.lighten(root.paletteColor6, 0.4)
        property color m3primaryFixedDim: root.lighten(root.paletteColor6, 0.1)
        property color m3onPrimaryFixed: root.darken(root.paletteColor6, 0.6)
        property color m3onPrimaryFixedVariant: root.darken(root.paletteColor6, 0.3)

        property color m3secondaryFixed: root.lighten(root.paletteColor5, 0.4)
        property color m3secondaryFixedDim: root.lighten(root.paletteColor5, 0.2)
        property color m3onSecondaryFixed: root.darken(root.paletteColor5, 0.6)
        property color m3onSecondaryFixedVariant: root.darken(root.paletteColor5, 0.3)

        property color m3tertiaryFixed: root.lighten(root.paletteColor4, 0.3)
        property color m3tertiaryFixedDim: root.lighten(root.paletteColor4, 0.1)
        property color m3onTertiaryFixed: root.darken(root.paletteColor4, 0.6)
        property color m3onTertiaryFixedVariant: root.darken(root.paletteColor4, 0.3)

        // Additional helpers
        property color success: root.paletteColor3
        property color onSuccess: root.darken(root.paletteColor1, 0.1)
        property color warning: root.paletteColor5
        property color onWarning: root.darken(root.paletteColor1, 0.1)
        property color info: root.paletteColor7
        property color onInfo: root.darken(root.paletteColor1, 0.1)
    }
    // Instantiate the palette
    property M3Palette palette: M3Palette {}
}
