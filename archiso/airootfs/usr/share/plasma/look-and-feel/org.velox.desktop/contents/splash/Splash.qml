import QtQuick 2.15

Rectangle {
    id: root
    color: "#000000"

    property int stage: 0

    onStageChanged: {
        if (stage === 1) fadeIn.start()
        if (stage === 5) fadeOut.start()
    }

    // ── background image ──────────────────────────────────────────────────────
    Image {
        anchors.fill: parent
        source: "images/background.png"
        fillMode: Image.PreserveAspectCrop
        smooth: true
    }

    // ── spinning dot circle ───────────────────────────────────────────────────
    Item {
        id: spinner
        width: 64; height: 64
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.bottom: parent.bottom
        anchors.bottomMargin: parent.height * 0.08
        opacity: 0

        property real angle: 0

        RotationAnimation on angle {
            from: 0; to: 360
            duration: 1200
            loops: Animation.Infinite
            running: true
        }

        Repeater {
            model: 10
            Rectangle {
                property real rad: (index / 10.0) * Math.PI * 2
                property real dist: 26
                x: spinner.width  / 2 + Math.cos(rad) * dist - width  / 2
                y: spinner.height / 2 + Math.sin(rad) * dist - height / 2
                width: 6; height: 6; radius: 3
                opacity: (index + 1) / 10.0
                color: "#c8c8c8"

                transform: Rotation {
                    origin.x: 3; origin.y: 3
                    angle: spinner.angle
                    Behavior on angle {}
                }
            }
        }
    }

    // ── minimum display timer (3 s) ───────────────────────────────────────────
    Timer {
        id: minTimer
        interval: 3000
        running: false
        onTriggered: if (root.stage >= 5) fadeOut.start()
    }

    // ── fade in ───────────────────────────────────────────────────────────────
    NumberAnimation {
        id: fadeIn
        target: spinner
        property: "opacity"
        from: 0; to: 1
        duration: 600
        easing.type: Easing.OutCubic
        onStarted: minTimer.start()
    }

    // ── fade out whole screen ─────────────────────────────────────────────────
    NumberAnimation {
        id: fadeOut
        target: root
        property: "opacity"
        from: 1; to: 0
        duration: 500
        easing.type: Easing.InCubic
    }
}
