/*
 * Copyright (c) 2013 Christoph Schulz
 *
 * This program is free software; you can redistribute it and/or modify it under
 * the terms of the GNU Lesser General Public License as published by the Free
 * Software Foundation; either version 2.1 of the License, or (at your option)
 * any later version.
 *
 * This program is distributed in the hope that it will be useful, but WITHOUT
 * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
 * FOR A PARTICULAR PURPOSE. See the GNU Lesser General Public License for more
 * details: http://www.gnu.org/copyleft/lesser
 */
import QtQuick 2.0
import OGDF 1.0

CanvasView {
    id: graphView
    property QtObject graph: null
    clip: true
    Item {
        id: graphScene
        x: childrenRect.x
        y: childrenRect.y
        width: childrenRect.width
        height: childrenRect.height
        Repeater {
            model: graphView.graph.edges
            delegate: Canvas {
                property int headSize: 10
                property color color: '#ffffff'
                property int sourceX: model.sourceX
                property int sourceY: model.sourceY
                property int targetX: model.targetX
                property int targetY: model.targetY
                property int minX: Math.min(sourceX, targetX)
                property int minY: Math.min(sourceY, targetY)
                property int maxX: Math.max(sourceX, targetX)
                property int maxY: Math.max(sourceY, targetY)
                property var bends: model.bends
                x: minX - headSize / 2
                y: minY - headSize / 2
                width: maxX - minX + headSize + 1
                height: maxY - minY + headSize + 1
                antialiasing: true
                onBendsChanged: requestPaint()
                onPaint: {
                    var context = getContext('2d');
                    // Push.
                    context.save();
                    context.clearRect(0, 0, width, height);
                    context.strokeStyle = color;
                    context.lineWidth = 1;
                    context.beginPath();
                    // Draw line.
                    for (var i = 0; i < bends.length; ++i) {
                        if (i == 0) {
                            context.moveTo(bends[i].x - x, bends[i].y - y);
                        } else {
                            context.lineTo(bends[i].x - x, bends[i].y - y);
                        }
                    }
                    // Draw head.
                    var fromX = bends[0].x - x;
                    var fromY = bends[0].y - y;
                    var toX = bends[bends.length - 1].x - x;
                    var toY = bends[bends.length - 1].y - y;
                    var angle = Math.atan2(toY - fromY, toX - fromX);
                    context.lineTo(toX - headSize * Math.cos(angle - Math.PI / 8),
                                   toY - headSize * Math.sin(angle - Math.PI / 8));
                    context.moveTo(toX, toY);
                    context.lineTo(toX - headSize * Math.cos(angle + Math.PI / 8),
                                   toY - headSize * Math.sin(angle + Math.PI / 8));
                    // Pop.
                    context.stroke();
                    context.restore();
                }
                Behavior on sourceX {
                    NumberAnimation {
                        duration: 500
                    }
                }
                Behavior on sourceY {
                    NumberAnimation {
                        duration: 500
                    }
                }
                Behavior on targetX {
                    NumberAnimation {
                        duration: 500
                    }
                }
                Behavior on targetY {
                    NumberAnimation {
                        duration: 500
                    }
                }
            }
        }
        Repeater {
            model: graphView.graph.nodes
            delegate: Rectangle {
                x: model.x - model.width / 2
                y: model.y - model.height / 2
                width: model.width
                height: model.height
                color: "#49483e"
                radius: 4
                border.width: 1
                border.color: "#af9476"
                Behavior on x {
                    NumberAnimation {
                        duration: 500
                    }
                }
                Behavior on y {
                    NumberAnimation {
                        duration: 500
                    }
                }
                Text {
                    id: indexLabel
                    anchors.top: parent.top
                    anchors.topMargin: 2
                    anchors.horizontalCenter: parent.horizontalCenter
                    font.pixelSize: 12
                    color: "#ffffff"
                    text: model.index
                }
                Text {
                    anchors.bottom: parent.bottom
                    anchors.bottomMargin: 2
                    anchors.horizontalCenter: parent.horizontalCenter
                    font.pixelSize: 8
                    color: "#ffffff"
                    text: model.x.toFixed(0) + " " + model.y.toFixed(0)
                }
            }
        }
    }
}
