pragma Singleton
import Quickshell

Singleton {
    function parseTime(seconds: real): var {
        var hours = Math.floor(seconds / 3600);
        var minutes = Math.floor((seconds % 3600) / 60);
        var lastSeconds = Math.floor((seconds % 60));

        return {
            hours,
            minutes,
            lastSeconds
        };
    }

    function dateStringToUnix(dateStr: string): real {
        // Month abbreviations mapping
        var months = {
            "Jan": 0,
            "Feb": 1,
            "Mar": 2,
            "Apr": 3,
            "May": 4,
            "Jun": 5,
            "Jul": 6,
            "Aug": 7,
            "Sep": 8,
            "Oct": 9,
            "Nov": 10,
            "Dec": 11
        };

        // Parse the string - example: "15 Dec 14:30:25"
        var parts = dateStr.split(' ');
        if (parts.length !== 3) {
            console.error("Invalid date format. Expected: 'd MMM hh:mm:ss'");
            return 0;
        }

        var day = parseInt(parts[0], 10);
        var monthStr = parts[1];
        var timeParts = parts[2].split(':');

        if (timeParts.length !== 3) {
            console.error("Invalid time format. Expected: 'hh:mm:ss'");
            return 0;
        }

        var hours = parseInt(timeParts[0], 10);
        var minutes = parseInt(timeParts[1], 10);
        var seconds = parseInt(timeParts[2], 10);

        // Get month number from abbreviation
        var month = months[monthStr];
        if (month === undefined) {
            console.error("Invalid month abbreviation:", monthStr);
            return 0;
        }

        // Create date object - assuming current year if not specified
        var currentYear = new Date().getFullYear();
        var date = new Date(currentYear, month, day, hours, minutes, seconds);

        // Return UNIX timestamp (seconds since epoch)
        return Math.floor(date.getTime());
    }
}
