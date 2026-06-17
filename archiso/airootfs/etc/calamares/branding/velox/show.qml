/* Velox Linux Calamares Slideshow */
import QtQuick 2.0
import calamares.slideshow 1.0

Presentation {
    id: presentation

    function nextSlide() {
        presentation.goToNextSlide()
    }

    Timer {
        id: advanceTimer
        interval: 5000
        running: true
        repeat: true
        onTriggered: nextSlide()
    }

    Slide {
        anchors.fill: parent
        Image {
            anchors.fill: parent
            source: "velox-wall-1.png"
            fillMode: Image.PreserveAspectCrop
        }
        Rectangle {
            anchors.fill: parent
            color: "#44000000"
        }
        Column {
            anchors.centerIn: parent
            spacing: 20
            Rectangle {
                anchors.horizontalCenter: parent.horizontalCenter
                color: "#aa000000"
                radius: 8
                width: titleText1.width + 40
                height: titleText1.height + 20
                Text {
                    id: titleText1
                    anchors.centerIn: parent
                    text: "Welcome to Velox Linux"
                    color: "#ffffff"
                    font.pixelSize: 36
                    font.bold: true
                }
            }
            Rectangle {
                anchors.horizontalCenter: parent.horizontalCenter
                color: "#aa000000"
                radius: 8
                width: subText1.width + 40
                height: subText1.height + 16
                Text {
                    id: subText1
                    anchors.centerIn: parent
                    text: "Shape It. Race It. Own It."
                    color: "#6dab74"
                    font.pixelSize: 22
                }
            }
        }
    }

    Slide {
        anchors.fill: parent
        Image {
            anchors.fill: parent
            source: "velox-wall-2.png"
            fillMode: Image.PreserveAspectCrop
        }
        Rectangle {
            anchors.fill: parent
            color: "#44000000"
        }
        Column {
            anchors.centerIn: parent
            spacing: 20
            Rectangle {
                anchors.horizontalCenter: parent.horizontalCenter
                color: "#aa000000"
                radius: 8
                width: titleText2.width + 40
                height: titleText2.height + 20
                Text {
                    id: titleText2
                    anchors.centerIn: parent
                    text: "KDE Plasma Desktop"
                    color: "#ffffff"
                    font.pixelSize: 36
                    font.bold: true
                }
            }
            Rectangle {
                anchors.horizontalCenter: parent.horizontalCenter
                color: "#aa000000"
                radius: 8
                width: subText2.width + 40
                height: subText2.height + 16
                Text {
                    id: subText2
                    anchors.centerIn: parent
                    text: "A modern, powerful, and beautiful desktop environment"
                    color: "#6dab74"
                    font.pixelSize: 18
                }
            }
        }
    }

    Slide {
        anchors.fill: parent
        Image {
            anchors.fill: parent
            source: "velox-wall-3.png"
            fillMode: Image.PreserveAspectCrop
        }
        Rectangle {
            anchors.fill: parent
            color: "#44000000"
        }
        Column {
            anchors.centerIn: parent
            spacing: 20
            Rectangle {
                anchors.horizontalCenter: parent.horizontalCenter
                color: "#aa000000"
                radius: 8
                width: titleText3.width + 40
                height: titleText3.height + 20
                Text {
                    id: titleText3
                    anchors.centerIn: parent
                    text: "Built for Creators"
                    color: "#ffffff"
                    font.pixelSize: 36
                    font.bold: true
                }
            }
            Rectangle {
                anchors.horizontalCenter: parent.horizontalCenter
                color: "#aa000000"
                radius: 8
                width: subText3.width + 40
                height: subText3.height + 16
                Text {
                    id: subText3
                    anchors.centerIn: parent
                    text: "Kdenlive, OBS Studio, GIMP and Inkscape included"
                    color: "#6dab74"
                    font.pixelSize: 18
                }
            }
        }
    }

    Slide {
        anchors.fill: parent
        Image {
            anchors.fill: parent
            source: "velox-wall-4.png"
            fillMode: Image.PreserveAspectCrop
        }
        Rectangle {
            anchors.fill: parent
            color: "#44000000"
        }
        Column {
            anchors.centerIn: parent
            spacing: 20
            Rectangle {
                anchors.horizontalCenter: parent.horizontalCenter
                color: "#aa000000"
                radius: 8
                width: titleText4.width + 40
                height: titleText4.height + 20
                Text {
                    id: titleText4
                    anchors.centerIn: parent
                    text: "Arch Linux Based"
                    color: "#ffffff"
                    font.pixelSize: 36
                    font.bold: true
                }
            }
            Rectangle {
                anchors.horizontalCenter: parent.horizontalCenter
                color: "#aa000000"
                radius: 8
                width: subText4.width + 40
                height: subText4.height + 16
                Text {
                    id: subText4
                    anchors.centerIn: parent
                    text: "Rolling release — always up to date"
                    color: "#6dab74"
                    font.pixelSize: 18
                }
            }
        }
    }
}
