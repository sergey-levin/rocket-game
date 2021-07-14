/*
# #####################################################
# Copyright (C) Sergey Levin - All Rights Reserved
# Written by Sergey Levin <liteswamp@gmail.com>, 2021
# #####################################################
 */

import QtQuick 2.15
import QtQuick.Particles 2.12

Item {
    id: explosion
    anchors.fill: parent

    function burst(x, y) {
        flameEmitter.burst(1000, x , y)
        debrisEmitter.burst(200, x , y)

    }

    Component.onCompleted: {
        // Fix strange bug with not colored particles if emitRate set to 0 in Emitter
        flameEmitter.emitRate = 0
        debrisEmitter.emitRate = 0
    }

    ParticleSystem {
        id: particles
        anchors.fill: parent

        ImageParticle {
            z: 20
            anchors.fill: parent
            system: particles
            source: "qrc:///particleresources/glowdot.png"
            colorVariation: 0.2
            color: "red"
            groups: ["B"]
        }

        ImageParticle {
            z: 10
            anchors.fill: parent
            system: particles
            source: "qrc:///particleresources/glowdot.png"
            colorVariation: 0.2
            color: "yellow"
            groups: ["A"]
        }

        Emitter {
            id: flameEmitter
            lifeSpan: 500
            acceleration: AngleDirection {angleVariation: 360; magnitude: 100; magnitudeVariation: 100}
            velocity: AngleDirection {angleVariation: 360; magnitude: 100; magnitudeVariation: 100}
            size: 20
            sizeVariation: 8
            endSize: 2
            group: "A"
        }

        Emitter {
            id: debrisEmitter
            lifeSpan: 1200
            acceleration: AngleDirection {angleVariation: 360; magnitude: 10; magnitudeVariation: 100}
            velocity: AngleDirection {angleVariation: 360; magnitude: 10; magnitudeVariation: 100}
            size: 40
            sizeVariation: 8
            endSize: 4
            group: "B"
        }

        Gravity {
            anchors.fill: parent
            magnitude: 100
            angle: 90
        }
    }

}
