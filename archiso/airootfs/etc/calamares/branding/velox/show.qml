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
            color: "#aa000000"
        }
        Column {
            anchors.centerIn: parent
            spacing: 20
            Text {
                anchors.horizontalCenter: parent.horizontalCenter
                text: "Welcome to Velox Linux"
                color: "#ffffff"
                font.pixelSize: 36
                font.bold: true
            }
            Text {
                anchors.horizontalCenter: parent.horizontalCenter
                text: "Shape It. Race It. Own It."
                color: "#5a8160"
                font.pixelSize: 22
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
            color: "#aa000000"
        }
        Column {
            anchors.centerIn: parent
            spacing: 20
            Text {
                anchors.horizontalCenter: parent.horizontalCenter
                text: "KDE Plasma Desktop"
                color: "#ffffff"
                font.pixelSize: 36
                font.bold: true
            }
            Text {
                anchors.horizontalCenter: parent.horizontalCenter
                text: "A modern, powerful, and beautiful desktop environment"
                color: "#5a8160"
                font.pixelSize: 18
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
            color: "#aa000000"
        }
        Column {
            anchors.centerIn: parent
            spacing: 20
            Text {
                anchors.horizontalCenter: parent.horizontalCenter
                text: "Built for Creators"
                color: "#ffffff"
                font.pixelSize: 36
                font.bold: true
            }
            Text {
                anchors.horizontalCenter: parent.horizontalCenter
                text: "Kdenlive, OBS Studio, GIMP and Inkscape included"
                color: "#5a8160"
                font.pixelSize: 18
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
            color: "#aa000000"
        }
        Column {
            anchors.centerIn: parent
            spacing: 20
            Text {
                anchors.horizontalCenter: parent.horizontalCenter
                text: "Arch Linux Based"
                color: "#ffffff"
                font.pixelSize: 36
                font.bold: true
            }
            Text {
                anchors.horizontalCenter: parent.horizontalCenter
                text: "Rolling release — always up to date"
                color: "#5a8160"
                font.pixelSize: 18
            }
        }
    }
}
