import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import SddmComponents 2.0

Rectangle {
    id: root
    width: 1920
    height: 1080
    color: "#1a1a1a"

    // Background
    Image {
        id: backgroundImage
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

    // Center login box
    Rectangle {
        id: loginBox
        anchors.centerIn: parent
        width: 400
        height: 480
        color: "#cc1a1a1a"
        radius: 12
        border.color: "#5a8160"
        border.width: 1

        ColumnLayout {
            anchors.centerIn: parent
            spacing: 20
            width: parent.width - 60

            // Logo
            Image {
                Layout.alignment: Qt.AlignHCenter
                source: "logo.png"
                width: 180
                height: 120
                fillMode: Image.PreserveAspectFit
            }

            // Welcome text
            Text {
                Layout.alignment: Qt.AlignHCenter
                text: "Welcome to Velox Linux"
                color: "#ffffff"
                font.pixelSize: 18
                font.bold: true
            }

            // Username field
            TextField {
                id: userField
                Layout.fillWidth: true
                placeholderText: "Username"
                text: userModel.lastUser
                font.pixelSize: 14
                color: "#ffffff"
                background: Rectangle {
                    color: "#2a2a2a"
                    radius: 6
                    border.color: "#5a8160"
                    border.width: 1
                }
                padding: 10
            }

            // Password field
            TextField {
                id: passwordField
                Layout.fillWidth: true
                placeholderText: "Password"
                echoMode: TextInput.Password
                passwordCharacter: "●"
                font.pixelSize: 14
                color: "#ffffff"
                background: Rectangle {
                    color: "#2a2a2a"
                    radius: 6
                    border.color: "#5a8160"
                    border.width: 1
                }
                padding: 10
                Keys.onReturnPressed: loginButton.clicked()
            }

            // Login button
            Button {
                id: loginButton
                Layout.fillWidth: true
                text: "Login"
                font.pixelSize: 14
                font.bold: true
                contentItem: Text {
                    text: loginButton.text
                    color: "#ffffff"
                    font: loginButton.font
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                }
                background: Rectangle {
                    color: loginButton.pressed ? "#3d5c40" : loginButton.hovered ? "#6dab74" : "#5a8160"
                    radius: 6
                }
                onClicked: sddm.login(userField.text, passwordField.text, sessionIndex)
            }

            // Tagline
            Text {
                Layout.alignment: Qt.AlignHCenter
                text: "Shape It. Race It. Own It."
                color: "#5a8160"
                font.pixelSize: 12
            }
        }
    }

    // Power buttons
    Row {
        anchors.bottom: parent.bottom
        anchors.right: parent.right
        anchors.margins: 20
        spacing: 10

        Button {
            text: "Reboot"
            font.pixelSize: 12
            contentItem: Text {
                text: parent.text
                color: "#ffffff"
                font: parent.font
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
            }
            background: Rectangle {
                color: parent.hovered ? "#5a8160" : "#2a2a2a"
                radius: 6
                border.color: "#5a8160"
                border.width: 1
            }
            onClicked: sddm.reboot()
        }

        Button {
            text: "Shutdown"
            font.pixelSize: 12
            contentItem: Text {
                text: parent.text
                color: "#ffffff"
                font: parent.font
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
            }
            background: Rectangle {
                color: parent.hovered ? "#cc3333" : "#2a2a2a"
                radius: 6
                border.color: "#cc3333"
                border.width: 1
            }
            onClicked: sddm.powerOff()
        }
    }

    // Clock
    Text {
        anchors.top: parent.top
        anchors.right: parent.right
        anchors.margins: 20
        text: Qt.formatDateTime(new Date(), "hh:mm")
        color: "#ffffff"
        font.pixelSize: 48
        font.bold: true

        Timer {
            interval: 1000
            running: true
            repeat: true
            onTriggered: parent.text = Qt.formatDateTime(new Date(), "hh:mm")
        }
    }

    // Date
    Text {
        anchors.top: parent.top
        anchors.right: parent.right
        anchors.topMargin: 80
        anchors.rightMargin: 20
        text: Qt.formatDateTime(new Date(), "dddd, MMMM d yyyy")
        color: "#aaffffff"
        font.pixelSize: 16
    }
}
