/*
# #####################################################
# Copyright (C) Sergey Levin - All Rights Reserved
# Written by Sergey Levin <liteswamp@gmail.com>, 2021
# #####################################################
 */

import QtQuick 2.15

Image {
    id: wall
    x: parent.width
    y: Math.random() * parent.height
    smooth: true
    source: "images/cloud" + (Math.floor(Math.random() * 5) + 1) + ".png"

    readonly property double speed: -0.5 * Math.random() - 0.1

    z: 1/speed - 1

    function advance() {
        x = x + speed
    }
}
