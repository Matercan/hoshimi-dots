pragma Singleton
import Quickshell

Singleton {
    property int widgetHeight: 0

    function setHeight(height: int): void {
        console.log(height);
        widgetHeight = Math.max(widgetHeight, height);
        console.log(widgetHeight);
    }
}
