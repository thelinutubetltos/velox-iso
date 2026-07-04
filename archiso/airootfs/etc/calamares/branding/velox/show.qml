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
            source: "velox-slide-8.png"
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
            source: "velox-slide-9.png"
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
                    text: "Choose Your Desktop"
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
                    text: "KDE Plasma, Cinnamon, or XFCE — pick the perfect fit"
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
            source: "velox-slide-10.png"
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
            source: "velox-slide-11.png"
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

    Slide {
        anchors.fill: parent
        Image {
            anchors.fill: parent
            source: "velox-slide-12.png"
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
                width: titleText5.width + 40
                height: titleText5.height + 20
                Text {
                    id: titleText5
                    anchors.centerIn: parent
                    text: "Btrfs Support"
                    color: "#ffffff"
                    font.pixelSize: 36
                    font.bold: true
                }
            }
            Rectangle {
                anchors.horizontalCenter: parent.horizontalCenter
                color: "#aa000000"
                radius: 8
                width: subText5.width + 40
                height: subText5.height + 16
                Text {
                    id: subText5
                    anchors.centerIn: parent
                    text: "Automatic snapshots with Snapper keep your system safe"
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
            source: "velox-slide-13.png"
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
                width: titleText6.width + 40
                height: titleText6.height + 20
                Text {
                    id: titleText6
                    anchors.centerIn: parent
                    text: "Gaming Ready"
                    color: "#ffffff"
                    font.pixelSize: 36
                    font.bold: true
                }
            }
            Rectangle {
                anchors.horizontalCenter: parent.horizontalCenter
                color: "#aa000000"
                radius: 8
                width: subText6.width + 40
                height: subText6.height + 16
                Text {
                    id: subText6
                    anchors.centerIn: parent
                    text: "NVIDIA, AMD and Intel GPU drivers out of the box"
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
            source: "velox-slide-14.png"
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
                width: titleText7.width + 40
                height: titleText7.height + 20
                Text {
                    id: titleText7
                    anchors.centerIn: parent
                    text: "AUR & Chaotic-AUR"
                    color: "#ffffff"
                    font.pixelSize: 36
                    font.bold: true
                }
            }
            Rectangle {
                anchors.horizontalCenter: parent.horizontalCenter
                color: "#aa000000"
                radius: 8
                width: subText7.width + 40
                height: subText7.height + 16
                Text {
                    id: subText7
                    anchors.centerIn: parent
                    text: "Thousands of packages at your fingertips"
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
            source: "velox-slide-15.png"
            fillMode: Image.PreserveAspectCrop
        }
        Rectangle {
            anchors.fill: parent
            color: "#88000000"
        }
        Column {
            anchors.centerIn: parent
            spacing: 16
            Rectangle {
                anchors.horizontalCenter: parent.horizontalCenter
                color: "#aa000000"
                radius: 8
                width: titleTextCC.width + 40
                height: titleTextCC.height + 20
                Text {
                    id: titleTextCC
                    anchors.centerIn: parent
                    text: "Velox Control Center"
                    color: "#ffffff"
                    font.pixelSize: 36
                    font.bold: true
                }
            }
            Rectangle {
                anchors.horizontalCenter: parent.horizontalCenter
                color: "#22ffffff"
                radius: 10
                width: 660
                height: 370
                clip: true
                Image {
                    anchors.fill: parent
                    anchors.margins: 4
                    source: "velox-control-center.png"
                    fillMode: Image.PreserveAspectFit
                    smooth: true
                }
            }
            Rectangle {
                anchors.horizontalCenter: parent.horizontalCenter
                color: "#aa000000"
                radius: 8
                width: subTextCC.width + 40
                height: subTextCC.height + 16
                Text {
                    id: subTextCC
                    anchors.centerIn: parent
                    text: "Apps · GPU Drivers · Kernels · Snapshots · Updates — all in one place"
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
            source: "velox-slide-8.png"
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
                width: titleText8.width + 40
                height: titleText8.height + 20
                Text {
                    id: titleText8
                    anchors.centerIn: parent
                    text: "Almost There!"
                    color: "#ffffff"
                    font.pixelSize: 36
                    font.bold: true
                }
            }
            Rectangle {
                anchors.horizontalCenter: parent.horizontalCenter
                color: "#aa000000"
                radius: 8
                width: subText8.width + 40
                height: subText8.height + 16
                Text {
                    id: subText8
                    anchors.centerIn: parent
                    text: "Velox Linux is being installed on your system"
                    color: "#6dab74"
                    font.pixelSize: 18
                }
            }
        }
    }
}
