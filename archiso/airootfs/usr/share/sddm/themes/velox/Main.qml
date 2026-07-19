import QtQuick 2.15
import QtQuick.Layouts 1.15
import SddmComponents 2.0

Rectangle {
    id: root
    width: Screen.width
    height: Screen.height
    color: "#1a1a1a"

    // Invisible store so we can read session names by index
    Item {
        visible: false; width: 0; height: 0
        Repeater {
            id: sessionRepeater
            model: sessionModel
            delegate: Item { property string sessionName: name || "" }
        }
    }

    property int currentSessionIndex: sessionModel.lastIndex
    property string currentSessionName: ""

    onCurrentSessionIndexChanged: updateSessionName()

    function updateSessionName() {
        var item = sessionRepeater.itemAt(currentSessionIndex)
        currentSessionName = item ? item.sessionName : ""
    }

    // Background wallpaper
    Image {
        anchors.fill: parent
        source: config.background
        fillMode: Image.PreserveAspectCrop
        asynchronous: true
    }

    // Dark overlay
    Rectangle {
        anchors.fill: parent
        color: "#99000000"
    }

    // Clock — top right
    Column {
        anchors.top: parent.top
        anchors.right: parent.right
        anchors.margins: 28
        spacing: 4

        Text {
            anchors.right: parent.right
            text: Qt.formatDateTime(new Date(), "hh:mm")
            color: "#ffffff"
            font.pixelSize: 52
            font.bold: true
            Timer { interval: 1000; running: true; repeat: true; onTriggered: parent.text = Qt.formatDateTime(new Date(), "hh:mm") }
        }
        Text {
            anchors.right: parent.right
            text: Qt.formatDateTime(new Date(), "dddd, MMMM d yyyy")
            color: "#ccffffff"
            font.pixelSize: 16
            Timer { interval: 60000; running: true; repeat: true; onTriggered: parent.text = Qt.formatDateTime(new Date(), "dddd, MMMM d yyyy") }
        }
    }

    // Login box — center
    Rectangle {
        id: loginBox
        anchors.centerIn: parent
        width: 420
        height: sessionModel.count > 1 ? 560 : 500
        color: "#dd1e1e1e"
        radius: 12
        border.color: "#6dab74"
        border.width: 1

        Column {
            anchors.centerIn: parent
            spacing: 16
            width: parent.width - 60

            // Logo — no background rect so it blends into the card
            Image {
                anchors.horizontalCenter: parent.horizontalCenter
                source: "logo.png"
                width: 160
                height: 160
                fillMode: Image.PreserveAspectFit
                smooth: true
            }

            // Welcome
            Text {
                anchors.horizontalCenter: parent.horizontalCenter
                text: "Welcome to Velox Linux"
                color: "#ffffff"
                font.pixelSize: 17
                font.bold: true
            }

            // Username field
            Rectangle {
                width: parent.width
                height: 40
                color: "#2a2a2a"
                radius: 6
                border.color: usernameInput.activeFocus ? "#6dab74" : "#444444"
                border.width: 1

                TextInput {
                    id: usernameInput
                    anchors.fill: parent
                    anchors.margins: 10
                    color: "#ffffff"
                    font.pixelSize: 14
                    verticalAlignment: TextInput.AlignVCenter
                    text: userModel.lastUser
                    Keys.onReturnPressed: passwordInput.forceActiveFocus()

                    Text {
                        anchors.fill: parent
                        verticalAlignment: Text.AlignVCenter
                        text: "Username"
                        color: "#666666"
                        font.pixelSize: 14
                        visible: parent.text.length === 0 && !parent.activeFocus
                    }
                }
            }

            // Password field
            Rectangle {
                width: parent.width
                height: 40
                color: "#2a2a2a"
                radius: 6
                border.color: passwordInput.activeFocus ? "#6dab74" : "#444444"
                border.width: 1

                TextInput {
                    id: passwordInput
                    anchors.fill: parent
                    anchors.margins: 10
                    color: "#ffffff"
                    font.pixelSize: 14
                    verticalAlignment: TextInput.AlignVCenter
                    echoMode: TextInput.Password
                    passwordCharacter: "●"
                    Keys.onReturnPressed: doLogin()

                    Text {
                        anchors.fill: parent
                        verticalAlignment: Text.AlignVCenter
                        text: "Password"
                        color: "#666666"
                        font.pixelSize: 14
                        visible: parent.text.length === 0 && !parent.activeFocus
                    }
                }
            }

            // Error message
            Text {
                id: errorText
                anchors.horizontalCenter: parent.horizontalCenter
                text: ""
                color: "#ff6b6b"
                font.pixelSize: 13
                visible: text.length > 0
            }

            // Session switcher — left/right arrows, no popup
            Row {
                width: parent.width
                height: 40
                spacing: 4
                visible: sessionModel.count > 1

                // Left arrow
                Rectangle {
                    width: 36; height: 40
                    radius: 6
                    color: leftMouse.containsMouse ? "#4a8160" : "#2a2a2a"
                    border.color: "#6dab74"; border.width: 1
                    Text {
                        anchors.centerIn: parent
                        text: "◄"
                        color: "#6dab74"
                        font.pixelSize: 13
                    }
                    MouseArea {
                        id: leftMouse
                        anchors.fill: parent
                        hoverEnabled: true
                        onClicked: root.currentSessionIndex = (root.currentSessionIndex - 1 + sessionModel.count) % sessionModel.count
                    }
                }

                // Session name display
                Rectangle {
                    width: parent.width - 80
                    height: 40
                    color: "#2a2a2a"
                    radius: 6
                    border.color: "#444444"; border.width: 1
                    Text {
                        anchors.centerIn: parent
                        width: parent.width - 16
                        text: root.currentSessionName
                        color: "#ffffff"
                        font.pixelSize: 12
                        horizontalAlignment: Text.AlignHCenter
                        elide: Text.ElideRight
                    }
                }

                // Right arrow
                Rectangle {
                    width: 36; height: 40
                    radius: 6
                    color: rightMouse.containsMouse ? "#4a8160" : "#2a2a2a"
                    border.color: "#6dab74"; border.width: 1
                    Text {
                        anchors.centerIn: parent
                        text: "►"
                        color: "#6dab74"
                        font.pixelSize: 13
                    }
                    MouseArea {
                        id: rightMouse
                        anchors.fill: parent
                        hoverEnabled: true
                        onClicked: root.currentSessionIndex = (root.currentSessionIndex + 1) % sessionModel.count
                    }
                }
            }

            // Login button
            Rectangle {
                width: parent.width
                height: 40
                radius: 6
                color: loginMouse.pressed ? "#3d5c40" : loginMouse.containsMouse ? "#6dab74" : "#4a8160"

                Text {
                    anchors.centerIn: parent
                    text: "Login"
                    color: "#ffffff"
                    font.pixelSize: 14
                    font.bold: true
                }

                MouseArea {
                    id: loginMouse
                    anchors.fill: parent
                    hoverEnabled: true
                    cursorShape: Qt.PointingHandCursor
                    onClicked: doLogin()
                }

                Keys.onReturnPressed: doLogin()
            }

            // Tagline
            Text {
                anchors.horizontalCenter: parent.horizontalCenter
                text: "Shape It. Race It. Own It."
                color: "#6dab74"
                font.pixelSize: 12
            }
        }
    }

    // Power buttons — bottom right
    Row {
        anchors.bottom: parent.bottom
        anchors.right: parent.right
        anchors.margins: 20
        spacing: 10

        Rectangle {
            width: 90; height: 32
            radius: 6
            color: rebootMouse.containsMouse ? "#4a8160" : "#2a2a2a"
            border.color: "#6dab74"; border.width: 1
            Text { anchors.centerIn: parent; text: "Reboot"; color: "#ffffff"; font.pixelSize: 12 }
            MouseArea { id: rebootMouse; anchors.fill: parent; hoverEnabled: true; cursorShape: Qt.PointingHandCursor; onClicked: sddm.reboot() }
        }

        Rectangle {
            width: 90; height: 32
            radius: 6
            color: shutdownMouse.containsMouse ? "#7a3030" : "#2a2a2a"
            border.color: "#cc4444"; border.width: 1
            Text { anchors.centerIn: parent; text: "Shutdown"; color: "#ffffff"; font.pixelSize: 12 }
            MouseArea { id: shutdownMouse; anchors.fill: parent; hoverEnabled: true; cursorShape: Qt.PointingHandCursor; onClicked: sddm.powerOff() }
        }
    }

    Connections {
        target: sddm
        onLoginFailed: {
            errorText.text = "Wrong password — please try again"
            passwordInput.text = ""
            passwordInput.forceActiveFocus()
        }
    }

    function doLogin() {
        errorText.text = ""
        sddm.login(usernameInput.text, passwordInput.text, root.currentSessionIndex)
    }

    Component.onCompleted: {
        Qt.callLater(updateSessionName)
        usernameInput.forceActiveFocus()
    }
}
