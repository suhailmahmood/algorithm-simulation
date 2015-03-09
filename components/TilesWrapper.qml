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

	function tileAtXY(x, y) {
		return tilesRow.childAt(x,y)
	}

	function highlightTile(begin, end, color) {
		if(begin === -1) {
			for(var i=0; i<tileCount; i++)
				tileAtPos(i).tileColor = "green"
			return
		}
		if(!color)
			color = "gray"
		for(i=0; i<tileCount; i++) {
			if(i >= begin && i <= end) {
				tileAtPos(i).tileColor = color
			}
			else
				tileAtPos(i).tileColor = "green"
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
		// 55 coz each tile is 50 pixel wide, & has spacing of 5
		tileToMove.x = toPos * 55
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
//	Component.onCompleted: print(tileAtXY(55, 0).tileSize)
}
