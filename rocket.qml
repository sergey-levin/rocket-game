/*
# #####################################################
# Copyright (C) Sergey Levin - All Rights Reserved
# Written by Sergey Levin <liteswamp@gmail.com>, 2021
# #####################################################
 */

import QtQuick 2.15
import QtQuick.Particles 2.12

Item {
    id: rocket
    x: parent.width * 0.25
    y: parent.height * 0.5
    width: image.width
    height: image.height
    visible: false

    function ascend() {
        internal.speed = -internal.acceleration
    }

    function descend() {
        internal.speed = internal.acceleration
    }

    function hover() {
        internal.speed = 0
    }

    function advance() {
        y = y + internal.speed + internal.gravity
    }

    QtObject {
        id: internal

        property double speed: 0.5
        readonly property double gravity: 0.5
        readonly property double acceleration: 1

        // Rocket geometry approximated by rects
        property list<Rectangle> rects: [
            Rectangle { x: rocket.x; y: rocket.y; width: 55; height: rocket.height },
            Rectangle { x: rocket.x + 55; y: rocket.y + 2; width: 5; height: rocket.height - 4 },
            Rectangle { x: rocket.x + 60; y: rocket.y + 4; width: 5; height: rocket.height - 8 },
            Rectangle { x: rocket.x + 65; y: rocket.y + 6; width: 5; height: rocket.height - 12 },
            Rectangle { x: rocket.x + 70; y: rocket.y + 8; width: 5; height: rocket.height - 16 },
            Rectangle { x: rocket.x + 75; y: rocket.y + 12; width: 5; height: rocket.height - 24 }
        ]

        function doOverlap(r1, r2) {
            if (r1.width === 0 || r1.height === 0 || r2.width === 0 || r2.height === 0)
                return false

            if ((r1.x + r1.width) < r2.x || (r2.x + r2.width) < r1.x)
                return false

            if ((r1.y + r1.height) < r2.y || (r2.y + r2.height) < r1.y)
                return false

            return true
        }

        onSpeedChanged: {
            if (speed > 0)
                image.source = "images/rocket-up.png"
            else if (speed < 0)
                image.source = "images/rocket-down.png"
            else
                image.source = "images/rocket.png"
        }
    }

    function collision(rTop, rBottom) {
        for (var i = 0; i < internal.rects.length; i++) {
            var r = internal.rects[i]
            if (internal.doOverlap(r, rTop) || internal.doOverlap(r, rBottom))
                return true;
        }
        return false;
    }

    Image {
        id: image
        source: "images/rocket.png"
    }

    ParticleSystem {
        id: particles
        width: rocket.x
        height: rocket.parent.height

        ImageParticle {
            id: flame
            anchors.fill: parent
            system: particles
            source: "qrc:///particleresources/glowdot.png"
            colorVariation: 0.1
            color: "#00d12e11"
        }

        Emitter {
            x: -5
            height: rocket.height

            emitRate: 20
            lifeSpan: 1000

            acceleration: PointDirection {x: -20; xVariation: 10}
            velocity: PointDirection {x: -50; yVariation: 20}

            size: 24
            sizeVariation: 8
            endSize: 4
        }

        Turbulence {
            anchors.fill: parent
            strength: 32
        }
    }
}
