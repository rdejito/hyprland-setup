import QtQuick 2.0

Rectangle {
    id: chip

    property string label: ""
    property color accent: "#CBA6F7"
    property real scaleFactor: 1

    signal clicked()

    width: 104 * scaleFactor
    height: 38 * scaleFactor
    radius: height / 2

    color: "#99181825"
    border.color: "#44CBA6F7"
    border.width: 1

    Behavior on color { ColorAnimation { duration: 150 } }

    Text {
        anchors.centerIn: parent
        text: chip.label
        color: chip.accent
        font.family: "JetBrainsMono Nerd Font"
        font.pixelSize: 11 * scaleFactor
        font.bold: true
    }

    MouseArea {
        anchors.fill: parent
        hoverEnabled: true
        cursorShape: Qt.PointingHandCursor

        onEntered: chip.color = "#D91E1E2E"
        onExited: chip.color = "#99181825"
        onClicked: chip.clicked()
    }
}
