/*
# #####################################################
# Copyright (C) Sergey Levin - All Rights Reserved
# Written by Sergey Levin <liteswamp@gmail.com>, 2021
# #####################################################
 */

import QtQuick 2.15

Item {
    id: wall
    x: parent.width
    z: -1
    width: 32
    anchors.top: parent.top
    anchors.bottom: parent.bottom

    readonly property double speed: -1

    function advance() {
        x = x + speed
    }

    function r1() {
        return Qt.rect(x, top.y, top.width, top.height)
    }

    function r2() {
        return Qt.rect(x, bottom.y, bottom.width, bottom.height)
    }

    QtObject {
        id: gap
        readonly property int min: 80
        readonly property int size: Math.floor(Math.random() * 0.25 * parent.height)
    }

    Image {
        id: top
        anchors.top: parent.top
        width: parent.width
        height: Math.floor(Math.random() * 0.5 * parent.height);
        fillMode: Image.Tile
        horizontalAlignment: Image.AlignLeft
        verticalAlignment: Image.AlignBottom
        source: "images/crate.png"
    }

    Image {
        id: bottom
        y: top.y + top.height + Math.max(gap.size, gap.min)
        height: parent.height
        width: parent.width
        fillMode: Image.Tile
        horizontalAlignment: Image.AlignLeft
        verticalAlignment: Image.AlignTop
        source: "images/crate.png"
    }
}
