import QtQuick 2.0
import "../components"
import "../scripts/script.js" as Functions

Rectangle {
	id: insertion

	width: 892
	height: 300
	color: "#7185e8"
	radius: 10

	property int speed: 1000	// minimum safe value is XXX, more causes tiles to be misplaced
	property int i:1
	property int j
	property alias temp: temp
	property alias tileCount: tilesRow.tileCount
	property var element1
	property var element2
	property int currentLine

	MouseArea {
		anchors.fill: parent
		property var timers: []
		property int runningTimer: -1
		onClicked: {
			outerLoopTimer.running ? outerLoopTimer.stop() : outerLoopTimer.start()
		}
	}

	Text {
		id: jval
		text: "j:" + j + "\ni:" + i
		font.pixelSize: 30
	}

	Tile {
		id: temp
		anchors.left: parent.left
		anchors.verticalCenter: parent.verticalCenter
		tileSize: 0
		tileLabel: tileSize
	}

	TilesWrapper {
		id: tilesRow
		dataArray: Functions.getNRandom(5)
		anchors.verticalCenter: parent.verticalCenter
	}

	PseudoCodeWrapper {
		id: pseudoCode
		anchors.left: tilesRow.right
		anchors.verticalCenter: parent.verticalCenter
		pseudocode: [
			"for (i=2 to n)",
			"  temp = array[i]",
			"  j = i",
			"  while (j > 1 and array[j-1] > temp)",
			"    array[j] = array[j-1]",
			"    j = j - 1",
			"  array[j] = temp"
		]
	}

	Timer {
		id: outerLoopTimer
		interval: speed
		running: true
		repeat: true
		triggeredOnStart: true
		onTriggered: {
			pseudoCode.highlightLine(currentLine)
			switch(currentLine) {
			case 0:
				if(i < tileCount) {
					currentLine++
				}
				else {
					stop()
				}
				break
			case 1:
				temp.tileSize = tilesRow.tileAtPos(i).tileSize
				//				tilesRow.tileAtPos(i).opacity = 0
				currentLine++
				break
			case 2:
				j = i
				currentLine++
				break
			case 3:
				element1 = tilesRow.tileAtPos(j-1)
				//				element1.color = "gray"
				//				temp.color = "gray"
				if (j <= 0 || (element1.tileSize <= temp.tileSize)) {
					currentLine = 6
				}
				else {
					currentLine++
				}
				break
			case 4:
				tilesRow.tileAtPos(j).tileSize = tilesRow.tileAtPos(j-1).tileSize
				currentLine++
				break
			case 5:
				j--
				currentLine = 3
				break
			case 6:
				tilesRow.tileAtPos(j).tileSize = temp.tileSize
				//				tilesRow.tileAtPos(j).opacity = 1
				i++
				currentLine = 0
			}
		}
	}
}
