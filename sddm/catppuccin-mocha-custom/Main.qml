//
// Catppuccin Mocha "Nocturne" greeter
//
// A custom SDDM theme built on SDDM's maya component set.
// Layout: ambient wallpaper + glass login card + oversized clock.
//

import QtQuick 2.0
import SddmComponents 2.0

import "./components"

Rectangle {
    id: root

    property string sansFont: "Noto Sans"
    property string monoFont: "JetBrainsMono Nerd Font"

    property color cBase: config.primaryDark ? config.primaryDark : "#11111B"
    property color cSurface: config.primaryHue3 ? config.primaryHue3 : "#181825"
    property color cOverlay: config.primaryShade ? config.primaryShade : "#1E1E2E"
    property color cText: config.normalText ? config.normalText : "#CDD6F4"
    property color cSubtext: "#A6ADC8"
    property color cLavender: config.accentShade ? config.accentShade : "#CBA6F7"
    property color cPink: config.accentLight ? config.accentLight : "#F5C2E7"
    property color cGreen: config.successText ? config.successText : "#A6E3A1"
    property color cRed: config.failureText ? config.failureText : "#F38BA8"
    property color cYellow: config.warningText ? config.warningText : "#F9E2AF"
    property color cTeal: "#94E2D5"

    property real uiScale: Math.max(0.72, Math.min(width / 1920, height / 1080))
    property real cardWidth: Math.min(root.width * 0.41, 460 * uiScale)
    property real cardHeight: Math.min(root.height * 0.78, 560 * uiScale)
    property real sideMargin: Math.max(56 * uiScale, root.width * 0.07)

    property date now: new Date()
    property string greeting: {
        var h = root.now.getHours();
        if (h < 12) return "Good morning";
        if (h < 18) return "Good afternoon";
        return "Good evening";
    }
    property bool busy: false

    TextConstants { id: textConstants }

    Timer {
        interval: 1000
        running: true
        repeat: true
        onTriggered: root.now = new Date()
    }

    Connections {
        target: sddm

        onLoginSucceeded: {
            root.busy = false;
            statusText.text = textConstants.loginSucceeded;
            statusText.color = cGreen;
            animSuccess.start();
        }

        onLoginFailed: {
            root.busy = false;
            passwordBox.text = "";
            statusText.text = textConstants.loginFailed;
            statusText.color = cRed;
            animFailure.start();
        }

        onInformationMessage: {
            root.busy = false;
            statusText.text = message;
            statusText.color = cYellow;
            animFailure.start();
        }
    }

    signal tryLogin()

    onTryLogin: {
        if (root.busy)
            return;

        root.busy = true;
        statusText.text = textConstants.prompt;
        statusText.color = cSubtext;
        sddm.login(userNameBox.text, passwordBox.text, sessionBox.index);
    }

    //
    // Wallpaper
    //
    Background {
        anchors.fill: parent
        source: config.background
        fillMode: Image.PreserveAspectCrop
    }

    //
    // Dark scrim so the UI stays readable
    //
    Rectangle {
        anchors.fill: parent
        gradient: Gradient {
            GradientStop { position: 0.00; color: "#B311111B" }
            GradientStop { position: 0.55; color: "#D911111B" }
            GradientStop { position: 1.00; color: "#F011111B" }
        }
    }

    //
    // Ambient Catppuccin glows
    //
    Rectangle {
        width: 660 * uiScale
        height: 660 * uiScale
        x: -240 * uiScale
        y: -280 * uiScale
        radius: width / 2
        color: cLavender
        opacity: 0.10

        SequentialAnimation on opacity {
            running: true
            loops: Animation.Infinite
            NumberAnimation { to: 0.16; duration: 7000 }
            NumberAnimation { to: 0.10; duration: 7000 }
        }
    }

    Rectangle {
        width: 540 * uiScale
        height: 540 * uiScale
        x: root.width * 0.72
        y: root.height * 0.62
        radius: width / 2
        color: cPink
        opacity: 0.08

        SequentialAnimation on opacity {
            running: true
            loops: Animation.Infinite
            NumberAnimation { to: 0.14; duration: 9000 }
            NumberAnimation { to: 0.08; duration: 9000 }
        }
    }

    Rectangle {
        width: 280 * uiScale
        height: 280 * uiScale
        x: root.width * 0.46
        y: -120 * uiScale
        radius: width / 2
        color: cTeal
        opacity: 0.06
    }

    //
    // Decorative rings
    //
    Rectangle {
        x: root.width * 0.06
        y: root.height * 0.60
        width: 380 * uiScale
        height: 380 * uiScale
        radius: width / 2
        color: "transparent"
        border.color: cLavender
        border.width: 1
        opacity: 0.16
    }

    Rectangle {
        x: root.width * 0.06 + 34 * uiScale
        y: root.height * 0.60 + 34 * uiScale
        width: 312 * uiScale
        height: 312 * uiScale
        radius: width / 2
        color: "transparent"
        border.color: cPink
        border.width: 1
        opacity: 0.12
    }

    //
    // Hero / clock
    //
    Item {
        id: hero
        anchors.left: parent.left
        anchors.leftMargin: root.sideMargin
        anchors.verticalCenter: parent.verticalCenter
        width: Math.min(root.width * 0.48, 760 * uiScale)
        height: 500 * uiScale

        Rectangle {
            x: 0
            y: 4 * uiScale
            width: 46 * uiScale
            height: 3 * uiScale
            radius: 1.5 * uiScale
            color: cPink
        }

        Text {
            x: 0
            y: 24 * uiScale
            text: "A R C H   /   H Y P R L A N D"
            color: cLavender
            font.family: monoFont
            font.pixelSize: 12 * uiScale
            font.bold: true
        }

        Text {
            x: 0
            y: 64 * uiScale
            text: root.greeting
            color: cSubtext
            font.family: sansFont
            font.pixelSize: 24 * uiScale
        }

        Text {
            x: 0
            y: 98 * uiScale
            width: parent.width
            text: userModel.lastUser ? userModel.lastUser : "there"
            color: cText
            font.family: sansFont
            font.pixelSize: 46 * uiScale
            font.bold: true
            elide: Text.ElideRight
        }

        Row {
            x: 0
            y: 156 * uiScale
            height: 112 * uiScale
            spacing: 14 * uiScale

            Text {
                id: clockText
                anchors.verticalCenter: parent.verticalCenter
                text: Qt.formatDateTime(root.now, "hh:mm")
                color: cText
                font.family: monoFont
                font.pixelSize: 92 * uiScale
                font.weight: Font.Light
            }

            Text {
                anchors.verticalCenter: parent.verticalCenter
                anchors.verticalCenterOffset: 22 * uiScale
                text: Qt.formatDateTime(root.now, "AP")
                color: cLavender
                font.family: sansFont
                font.pixelSize: 18 * uiScale
                font.bold: true
            }
        }

        Text {
            x: 0
            y: 286 * uiScale
            text: Qt.formatDateTime(root.now, "dddd, d MMMM yyyy")
            color: cText
            font.family: sansFont
            font.pixelSize: 22 * uiScale
        }

        Rectangle {
            x: 0
            y: 330 * uiScale
            width: Math.min(parent.width, 360 * uiScale)
            height: 1
            color: "#44CDD6F4"
        }

        Text {
            x: 0
            y: 350 * uiScale
            text: "Ready on " + sddm.hostName
            color: cSubtext
            font.family: sansFont
            font.pixelSize: 15 * uiScale
        }

        Text {
            x: 0
            y: 376 * uiScale
            text: "Enter your password to continue"
            color: cLavender
            font.family: sansFont
            font.pixelSize: 15 * uiScale
        }
    }

    //
    // Card shadow
    //
    Rectangle {
        x: root.width - root.sideMargin - root.cardWidth
        y: (root.height - root.cardHeight) / 2 + 12 * uiScale
        width: root.cardWidth
        height: root.cardHeight
        radius: 24 * uiScale
        color: "#990A0A12"
    }

    //
    // Login card
    //
    Rectangle {
        id: card
        x: root.width - root.sideMargin - root.cardWidth
        y: (root.height - root.cardHeight) / 2
        width: root.cardWidth
        height: root.cardHeight
        radius: 24 * uiScale
        color: "#D9181825"
        border.color: "#66CBA6F7"
        border.width: 1

        Rectangle {
            x: 28 * uiScale
            y: 0
            width: parent.width - 56 * uiScale
            height: 2 * uiScale
            color: cLavender
            opacity: 0.85
        }

        Item {
            anchors.fill: parent
            anchors.margins: 32 * uiScale

            Item {
                id: cardHead
                width: parent.width
                height: 28 * uiScale

                Rectangle {
                    x: 0
                    y: 10 * uiScale
                    width: 8 * uiScale
                    height: 8 * uiScale
                    radius: 4 * uiScale
                    color: cGreen
                }

                Text {
                    x: 18 * uiScale
                    anchors.verticalCenter: parent.verticalCenter
                    text: "SIGN IN"
                    color: cText
                    font.family: monoFont
                    font.pixelSize: 12 * uiScale
                    font.bold: true
                }

                Text {
                    anchors.right: parent.right
                    anchors.verticalCenter: parent.verticalCenter
                    text: "MOCHA / " + sddm.hostName.toUpperCase()
                    color: cLavender
                    font.family: monoFont
                    font.pixelSize: 11 * uiScale
                }
            }

            Column {
                anchors.top: cardHead.bottom
                anchors.topMargin: 24 * uiScale
                width: parent.width
                spacing: 10 * uiScale

                Text {
                    width: parent.width
                    text: "USERNAME"
                    color: cSubtext
                    font.family: monoFont
                    font.pixelSize: 11 * uiScale
                    font.bold: true
                }

                TextBox {
                    id: userNameBox
                    width: parent.width
                    height: 46 * uiScale
                    color: "#241F30"
                    borderColor: "#313244"
                    focusColor: cLavender
                    hoverColor: cPink
                    radius: 10 * uiScale
                    textColor: cText
                    font.family: sansFont
                    font.pixelSize: 16 * uiScale

                    KeyNavigation.tab: passwordBox
                    KeyNavigation.backtab: loginButton

                    Keys.onReturnPressed: passwordBox.focus = true
                }

                Text {
                    width: parent.width
                    text: "PASSWORD"
                    color: cSubtext
                    font.family: monoFont
                    font.pixelSize: 11 * uiScale
                    font.bold: true
                }

                PasswordBox {
                    id: passwordBox
                    width: parent.width
                    height: 46 * uiScale
                    color: "#241F30"
                    borderColor: "#313244"
                    focusColor: cLavender
                    hoverColor: cPink
                    radius: 10 * uiScale
                    textColor: cText
                    font.family: sansFont
                    font.pixelSize: 16 * uiScale

                    image: "images/ic_warning_white_24px.svg"
                    tooltipEnabled: true
                    tooltipText: textConstants.capslockWarning
                    tooltipFG: cText
                    tooltipBG: "#313244"

                    KeyNavigation.tab: sessionBox
                    KeyNavigation.backtab: userNameBox

                    Keys.onPressed: {
                        if (event.key === Qt.Key_Return || event.key === Qt.Key_Enter) {
                            root.tryLogin();
                            event.accepted = true;
                        }
                    }
                }

                Item {
                    width: parent.width
                    height: 6 * uiScale
                }

                Row {
                    width: parent.width
                    height: 62 * uiScale
                    spacing: 12 * uiScale

                    Item {
                        width: (parent.width - 12 * uiScale) / 2
                        height: parent.height

                        Text {
                            x: 0
                            y: 0
                            text: "SESSION"
                            color: cSubtext
                            font.family: monoFont
                            font.pixelSize: 11 * uiScale
                            font.bold: true
                        }

                        ComboBox {
                            id: sessionBox
                            y: 20 * uiScale
                            width: parent.width
                            height: 40 * uiScale

                            model: sessionModel
                            index: sessionModel.lastIndex

                            color: "#241F30"
                            borderColor: "#313244"
                            focusColor: cLavender
                            hoverColor: cPink
                            textColor: cText
                            menuColor: "#EE181825"

                            font.family: sansFont
                            font.pixelSize: 14 * uiScale

                            arrowIcon: "images/ic_arrow_drop_down_white_24px.svg"
                            arrowColor: cLavender

                            KeyNavigation.tab: layoutBox
                            KeyNavigation.backtab: passwordBox
                        }
                    }

                    Item {
                        width: (parent.width - 12 * uiScale) / 2
                        height: parent.height

                        Text {
                            x: 0
                            y: 0
                            text: "LAYOUT"
                            color: cSubtext
                            font.family: monoFont
                            font.pixelSize: 11 * uiScale
                            font.bold: true
                        }

                        LayoutBox {
                            id: layoutBox
                            y: 20 * uiScale
                            width: parent.width
                            height: 40 * uiScale

                            color: "#241F30"
                            borderColor: "#313244"
                            focusColor: cLavender
                            hoverColor: cPink
                            textColor: cText
                            menuColor: "#EE181825"

                            font.family: sansFont
                            font.pixelSize: 14 * uiScale

                            arrowIcon: "images/ic_arrow_drop_down_white_24px.svg"
                            arrowColor: cLavender

                            rowDelegate: Component {
                                Rectangle {
                                    color: "transparent"

                                    Image {
                                        id: flag
                                        source: "/usr/share/sddm/flags/%1.png".arg(modelItem ? modelItem.modelData.shortName : "zz")
                                        anchors.left: parent.left
                                        anchors.top: parent.top
                                        anchors.bottom: parent.bottom
                                        anchors.margins: 4 * uiScale
                                        fillMode: Image.PreserveAspectFit
                                    }

                                    Text {
                                        anchors.left: flag.right
                                        anchors.top: parent.top
                                        anchors.bottom: parent.bottom
                                        anchors.margins: 4 * uiScale
                                        verticalAlignment: Text.AlignVCenter
                                        text: modelItem ? modelItem.modelData.shortName : "zz"
                                        color: cText
                                        font.family: sansFont
                                        font.pixelSize: 13 * uiScale
                                    }
                                }
                            }

                            KeyNavigation.tab: loginButton
                            KeyNavigation.backtab: sessionBox
                        }
                    }
                }

                Rectangle {
                    id: loginButton
                    width: parent.width
                    height: 50 * uiScale
                    radius: 12 * uiScale
                    gradient: Gradient {
                        GradientStop { position: 0.00; color: cLavender }
                        GradientStop { position: 1.00; color: cPink }
                    }

                    Behavior on opacity { NumberAnimation { duration: 120 } }

                    Text {
                        anchors.centerIn: parent
                        text: "Sign in  →"
                        color: "#11111B"
                        font.family: sansFont
                        font.pixelSize: 17 * uiScale
                        font.bold: true
                    }

                    MouseArea {
                        anchors.fill: parent
                        hoverEnabled: true
                        cursorShape: Qt.PointingHandCursor

                        onEntered: loginButton.opacity = 0.88
                        onExited: loginButton.opacity = 1.0
                        onClicked: root.tryLogin()
                    }

                    KeyNavigation.tab: userNameBox
                    KeyNavigation.backtab: layoutBox

                    Keys.onReturnPressed: root.tryLogin()
                    Keys.onSpacePressed: root.tryLogin()
                }

                Text {
                    id: statusText
                    width: parent.width
                    height: 22 * uiScale
                    text: textConstants.prompt
                    color: cSubtext
                    font.family: sansFont
                    font.pixelSize: 13 * uiScale
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                }

                Rectangle {
                    id: busyTrack
                    width: parent.width
                    height: 3 * uiScale
                    radius: 1.5 * uiScale
                    color: "#22CDD6F4"
                    visible: root.busy

                    Rectangle {
                        id: busyFill
                        width: 0
                        height: parent.height
                        radius: parent.radius
                        color: cLavender

                        SequentialAnimation on width {
                            running: root.busy
                            loops: Animation.Infinite
                            NumberAnimation { from: 0; to: busyTrack.width; duration: 1200 }
                            NumberAnimation { from: busyTrack.width; to: 0; duration: 600 }
                        }
                    }
                }
            }
        }

        SequentialAnimation {
            id: animSuccess
            running: false
            NumberAnimation { target: statusText; property: "opacity"; from: 0.25; to: 1.0; duration: 250 }
        }

        SequentialAnimation {
            id: animFailure
            running: false
            NumberAnimation { target: statusText; property: "opacity"; from: 0.25; to: 1.0; duration: 250 }
        }
    }

    //
    // Power controls
    //
    Row {
        anchors.right: card.right
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 36 * uiScale
        spacing: 10 * uiScale

        PowerChip {
            label: "SLEEP"
            accent: cYellow
            scaleFactor: root.uiScale
            onClicked: sddm.suspend()
        }

        PowerChip {
            label: "RESTART"
            accent: cTeal
            scaleFactor: root.uiScale
            onClicked: sddm.reboot()
        }

        PowerChip {
            label: "POWER OFF"
            accent: cRed
            scaleFactor: root.uiScale
            onClicked: sddm.powerOff()
        }
    }

    Text {
        anchors.left: hero.left
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 40 * uiScale
        text: "SDDM  •  CATPPUCCIN MOCHA"
        color: "#66CDD6F4"
        font.family: monoFont
        font.pixelSize: 11 * uiScale
    }

    Component.onCompleted: {
        userNameBox.text = userModel.lastUser ? userModel.lastUser : "";
        if (userNameBox.text === "")
            userNameBox.focus = true;
        else
            passwordBox.focus = true;
    }
}
