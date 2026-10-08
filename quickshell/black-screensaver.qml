import Quickshell
import Quickshell.Wayland
import QtQuick

ShellRoot {
    Variants {
        model: Quickshell.screens

        delegate: PanelWindow {
            id: window
            required property var modelData

            screen: modelData
            color: "black"

            anchors {
                top: true
                bottom: true
                left: true
                right: true
            }

            exclusionMode: ExclusionMode.Ignore

            WlrLayershell.layer: WlrLayer.Overlay
            WlrLayershell.keyboardFocus: WlrKeyboardFocus.Exclusive

            // Transparent mouse interceptor that hides the cursor
            MouseArea {
                anchors.fill: parent
                cursorShape: Qt.BlankCursor
                onClicked: Qt.quit()
            }

            // Keyboard input handler
            Item {
                anchors.fill: parent
                focus: true

                Component.onCompleted: forceActiveFocus()

                Keys.onPressed: Qt.quit()
            }
        }
    }
}