import QtQuick 2.0

Rectangle {
	id: root

	width: 552; height: 300
	color: "transparent"

	property int tileCount: repeater.model = 10
	property alias repeater: repeater

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

	Row {
		id: tilesRow
		anchors.horizontalCenter: parent.horizontalCenter
		anchors.verticalCenter: parent.verticalCenter
		spacing: 4
		Repeater {
			id: repeater
			model: tileCount
			delegate: Tile {
				id: delegate
				anchors.bottom: parent.bottom
				tileSize: Math.random() * 95 + 5
				tileLabel: tileSize
				property int pos: index

				Behavior on x {
					NumberAnimation {
						duration: 400
						easing.type: Easing.InOutBack
					}
				}
			}
		}
	}
}
