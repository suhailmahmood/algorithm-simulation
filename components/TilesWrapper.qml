import QtQuick 2.0
import "../scripts/script.js" as Functions

Rectangle {
	id: root

	width: 552; height: 300
	color: "transparent"

	property var dataArray: Functions.getNRandom()
	property int tileCount: dataArray.length

	function tileAtPos(pos) {
		for (var i=0; i<tileCount; i++) {
			if (repeater.itemAt(i).pos === pos) {
				return repeater.itemAt(i)
			}
		}
	}

	function swap(tile1, tile2) {
		var tempX = tile1.x
		var tempPos = tile1.pos
		tile1.x = tile2.x
		tile1.pos = tile2.pos
		tile2.x = tempX
		tile2.pos = tempPos
	}

	function moveToPos(tileToMove, toPos, yChange) {
		var x = tileAtPos(toPos).x
		tileToMove.x = x
		tileToMove.pos = toPos
		if(yChange) {
			tileToMove.y = yChange
		}
	}

	Row {
		id: tilesRow
		anchors.horizontalCenter: parent.horizontalCenter
		anchors.verticalCenter: parent.verticalCenter
		spacing: 5
		Repeater {
			id: repeater
			model: dataArray
			delegate: Tile {
				id: delegate
				tileSize: modelData

				property int pos: index

				Behavior on x {
					NumberAnimation {
						duration: 400
						easing.type: Easing.InOutBack
					}
				}
				Behavior on y {
					NumberAnimation {
						duration: 400
						easing.type: Easing.OutBack
					}
				}
			}
		}
	}
}
