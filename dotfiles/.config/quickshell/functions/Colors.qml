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
    * Transparentizes a color by a given factor.
    *
    * @param {string} color - The color (any Qt.color-compatible string).
    * @param {number} percentage - The amount to transparentize (0-1).
    * @returns {Qt.rgba} The resulting color.
    */
    function transparentize(color, percentage = 1) {
        var c = Qt.color(color);
        return Qt.rgba(c.r, c.g, c.b, c.a * (1 - percentage));
    }

    function lighten(color: color, factor) {
        let c = Qt.color(color);
        return Qt.rgba(c.r + c.r * factor, c.g + c.g * factor, c.b + c.b * factor);
    }

    function darken(color, factor) {
        let c = Qt.color(color);
        return Qt.rgba(c.r - c.r * factor, c.g - c.g * factor, c.b - c.b * factor);
    }

    function desaturate(color, factor) {
        // Convert to HSV, reduce saturation
        let hsv = Qt.hsva(color.hsvHue, color.hsvSaturation * (1 - factor), color.hsvValue, color.a);
        return hsv;
    }

    function adjustAlpha(color, alpha) {
        let c = Qt.color(color);
        return Qt.rgba(c.r, c.g, c.b, alpha);
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
    function interpolate(color1, color2, factor): color {
        var c1 = Qt.color(color1);
        var c2 = Qt.color(color2);
        return Qt.rgba(factor * c1.r + (1 - factor) * c2.r, factor * c1.g + (1 - factor) * c2.g, factor * c1.b + (1 - factor) * c2.b, factor * c1.a + (1 - factor) * c2.a);
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
        property bool xterm: false

        // Key Colors main colors
        property color m3primary_paletteKeyColor: root.paletteColor6
        property color m3secondary_paletteKeyColor: root.paletteColor5
        property color m3tertiary_paletteKeyColor: root.paletteColor4
        property color m3neutral_paletteKeyColor: root.paletteColor8
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

        //  Outline Colors
        property color m3outline: root.desaturate(root.paletteColor16, 0.4)
        property color m3outlineVariant: root.blend(root.paletteColor9, root.paletteColor16, 0.2)

        //  Utility Colors
        property color m3shadow: root.paletteColor1
        property color m3scrim: root.paletteColor1
        property color m3surfaceTint: root.lighten(root.paletteColor6, 0.2)

        //  Primary Colors
        property color m3primary: root.lighten(root.paletteColor6, 0.1)
        property color m3onPrimary: root.darken(root.paletteColor1, 0.1)
        property color m3primaryContainer: root.darken(root.paletteColor6, 0.3)
        property color m3onPrimaryContainer: root.lighten(root.paletteColor6, 0.4)
        property color m3inversePrimary: root.darken(root.paletteColor6, 0.2)

        //  Secondary Colors
        property color m3secondary: root.lighten(root.paletteColor5, 0.2)
        property color m3onSecondary: root.darken(root.paletteColor1, 0.1)
        property color m3secondaryContainer: root.darken(root.paletteColor5, 0.3)
        property color m3onSecondaryContainer: root.lighten(root.paletteColor5, 0.4)

        //  Tertiary Colors
        property color m3tertiary: root.lighten(root.paletteColor4, 0.1)
        property color m3onTertiary: root.darken(root.paletteColor1, 0.1)
        property color m3tertiaryContainer: root.darken(root.paletteColor4, 0.2)
        property color m3onTertiaryContainer: root.lighten(root.paletteColor4, 0.3)

        //   Error Colors
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

    property bool xterm
    property M3Palette palette: M3Palette {
        xterm: root.xterm

        // Key Colors main colors
        // property color m3primary_paletteKeyColor: ""
        // // property color m3secondary_paletteKeyColor: ""
        // property color m3tertiary_paletteKeyColor: ""
        // property color m3neutral_paletteKeyColor: ""
        // property color m3neutral_variant_paletteKeyColor: ""

        // Surface Colors (backgrounds)
        // property color m3background: ""
        // property color m3onBackground: ""

        // property color m3surface: ""
        // property color m3surfaceDim: ""
        // property color m3surfaceBright:  ""
        // property color m3surfaceContainerLowest:  ""
        // property color m3surfaceContainerLow:  ""
        // property color m3surfaceContainer: ""
        // property color m3surfaceContainerHigh: ""
        // property color m3surfaceContainerHighest:  ""
        // property color m3onSurface: ""
        // property color m3surfaceVariant: ""
        // property color m3onSurfaceVariant: ""

        // Inverse Colors
        // property color m3inverseSurface: ""
        // property color m3inverseOnSurface: ""

        // Outline Colors
        // property color m3outline: ""
        // property color m3outlineVariant: ""

        // Utility Colors
        // property color m3shadow: ""
        // property color m3scrim: ""
        // property color m3surfaceTint: ""

        // Primary Colors
        // property color m3primary: ""
        // // property color m3onPrimary: ""
        // property color m3primaryContainer: ""
        // property color m3onPrimaryContainer: ""
        // property color m3inversePrimary:""

        // Secondary Colors
        // property color m3secondary: ""
        // property color m3onSecondary: ""
        // property color m3secondaryContainer: ""
        // property color m3onSecondaryContainer: ""

        // Tertiary Colors
        // property color m3tertiary: ""
        // property color m3onTertiary: ""
        // property color m3tertiaryContainer: ""
        // property color m3onTertiaryContainer: ""

        // Error Colors
        // property color m3error: ""
        // property color m3onError: ""
        // property color m3errorContainer: ""
        // property color m3onErrorContainer: ""

        // Fixed Colors
        // property color m3primaryFixed: ""
        // property color m3primaryFixedDim: ""
        // property color m3onPrimaryFixed: ""
        // property color m3onPrimaryFixedVariant: ""

        // property color m3secondaryFixed: ""
        // property color m3secondaryFixedDim: ""
        // property color m3onSecondaryFixed: ""
        // property color m3onSecondaryFixedVariant: ""

        // property color m3tertiaryFixed: ""
        // property color m3tertiaryFixedDim: ""
        // property color m3onTertiaryFixed: ""
        // property color m3onTertiaryFixedVariant: ""

        // Additional helpers
        // property color success: ""
        // property color onSuccess: ""
        // property color warning: ""
        // property color onWarning: ""
        // property color info: ""
        // property color onInfo: ""

        property var amogus
    }
}
