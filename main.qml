/*
# #####################################################
# Copyright (C) Sergey Levin - All Rights Reserved
# Written by Sergey Levin <liteswamp@gmail.com>, 2021
# #####################################################
 */

import QtQuick 2.15
import QtQuick.Controls 2.12
import QtQuick.Window 2.15

Window {
    id: gameWindow
    width: 640
    height: 480
    maximumWidth: width
    maximumHeight: height
    minimumWidth: width
    minimumHeight: height
    visible: true
    title: qsTr("Rocket")

    readonly property int cloudPeriodMin: 3000
    readonly property int wallPeriodMin: 3000

    property int score: 0
    property Item rocket: Qt.createComponent("rocket.qml").createObject(gameWindow);
    property Item explosion: Qt.createComponent("explosion.qml").createObject(gameWindow);
    property list<Item> walls
    property list<Image> clouds

    Component.onCompleted: {
        x = Screen.width / 2 - width / 2
        y = Screen.height / 2 - height / 2
    }

    Item {
        anchors.fill: parent
        focus: true
        Keys.onPressed: {
            if (event.key === Qt.Key_Up) {
                rocket.ascend()
                event.accepted = true;
            }
            if (event.key === Qt.Key_Down) {
                rocket.descend()
                event.accepted = true;
            }
            if (event.key === Qt.Key_Escape) {
                Qt.quit()
                event.accepted = true;
            }
            if (event.key === Qt.Key_Enter || event.key === Qt.Key_Return) {
                wallTimer.running = true
                cloudTimer.running = true
                scoreTimer.running = true
                engineTimer.running = true
                instructionText.visible = false
                infoText.visible = false
                rocket.visible = true
                rocket.y = parent.height * 0.5
                score = 0
                for (var i = 0; i < walls.length; i++)
                    walls[i].destroy()
                walls = []
                for (i = 0; i < clouds.length; i++)
                    clouds[i].destroy()
                clouds = []

                event.accepted = true;
            }
        }
        Keys.onReleased: {
            if (event.key === Qt.Key_Up || event.key === Qt.Key_Down) {
                rocket.hover()
                event.accepted = true;
            }
        }

        Timer {
            id: wallTimer
            interval: wallPeriodMin
            repeat: true
            onTriggered: {
                var wall = Qt.createComponent("wall.qml");
                walls.push(wall.createObject(gameWindow, {}))
                interval = Math.floor(Math.random() * wallPeriodMin) + wallPeriodMin;
            }
        }

        Timer {
            id: cloudTimer
            interval: 100
            repeat: true
            onTriggered: {
                var cloud = Qt.createComponent("cloud.qml");
                clouds.push(cloud.createObject(gameWindow, {}))
                interval = Math.floor(Math.random() * cloudPeriodMin) + cloudPeriodMin;
            }
        }

        Timer {
            id: scoreTimer
            interval: 100
            repeat: true
            onTriggered: {
                time.text = qsTr("Score: ") + (++score)
            }
        }
    }

    Timer {
        id: engineTimer
        interval: 1
        repeat: true
        onTriggered: {
            rocket.advance()
            if (rocket.y < 0) rocket.y = 0

            for (var i = 0; i < walls.length; i++)
                walls[i].advance()

            for (i = 0; i < clouds.length; i++)
                clouds[i].advance()

            if (collision()) {
                explosion.burst(rocket.x + 0.5 * rocket.width, rocket.y + 0.5 * rocket.height)
                wallTimer.running = false
                cloudTimer.running = false
                scoreTimer.running = false
                engineTimer.running = false
                instructionText.visible = true
                infoText.text = qsTr("Game Over!")
                infoText.visible = true
                rocket.visible = false
            }
        }
    }

    function collision() {
        if ((rocket.y + rocket.height) >= ground.y)
            return true

        for (var i = 0; i < walls.length; i++) {
            if (rocket.collision(walls[i].r1(), walls[i].r2()))
                return true;
        }

        return false
    }

    Rectangle {
        //sky
        z: -1000
        anchors.fill: parent
        color: "#ff00bfff"
    }

    Rectangle {
        id: ground
        y: parent.height * 0.9
        width: parent.width
        height: parent.height * 0.1
        color: "#ff50bf2b"
    }

    Text {
        id: time
        z: 1
        anchors.bottom: parent.bottom
        anchors.left: parent.left
        anchors.leftMargin: 5
        font.pointSize: 15
        font.bold: true
        color: "#ffbf2b50"
    }

    Text {
        id: instructionText
        z: 10
        y: infoText.y + infoText.height
        anchors.horizontalCenter: parent.horizontalCenter
        font.pointSize: 15
        visible: true
        color: "#ffff4000"
        text: qsTr("Press Enter to start new game or press Esc to exit.")
    }

    Label {
        id: infoText
        z: 10
        y: parent.height * 0.35
        anchors.horizontalCenter: parent.horizontalCenter
        font.pointSize: 30
        font.bold: true
        visible: true
        color: "red"
        text: qsTr("ROCKET")

        background: Rectangle {
            radius: 10
            implicitWidth: 40
            implicitHeight: 40
            color: "#ffffff"

            Rectangle {
                color: "#21be2b"
                width: parent.width
                height: 1
                anchors.bottom: parent.bottom
            }
        }
    }
}


