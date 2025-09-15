pragma Singleton

import Quickshell

Singleton {
    function getProgressCoords(percentage: real, radius: real, centerX: real, centerY: real): var {
        // Start from top (12 o'clock) and go clockwise
        var angle = (percentage * 2 * Math.PI) - (Math.PI / 2);
        var xCoord = centerX + radius * Math.cos(angle);
        var yCoord = centerY + radius * Math.sin(angle);
        return [xCoord, yCoord];
    }
}
