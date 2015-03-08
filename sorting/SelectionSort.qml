import QtQuick 2.0
import "../components"
import "../scripts/script.js" as Functions

Rectangle {
	id: root

	width: 892
	height: 360
	color: "#f18912"

	property int speed: 500 // speed as low as 50 still works
	property int i
	property int j
	property int min_loc: 0
	property alias tileCount: tilesRow.tileCount
	property var element1
	property var element2
	property int currentLine
	property bool sorted: false

	Rectangle {
		id: mainArea
		anchors.centerIn: parent
		width: 892
		height: 300
		color: "transparent"

		TilesWrapper {
			id: tilesRow
			anchors.verticalCenter: parent.verticalCenter
		}


		PseudoCodeWrapper {
			id: pseudoCode
			height: 270
			anchors.left: tilesRow.right
			anchors.verticalCenter: parent.verticalCenter
			pseudocode: [
				"for (i=0 to n-2)",
				"{",
				"   min_loc = i",
				"   for (j=i+1 to n-1)",
				"   {",
				"      if (array[j] < array[min_loc])",
				"         min_loc = j",
				"   }",
				"   if (min_loc != i)",
				"      swap(array[min_loc], array[i])",
				"}"
			]
		}

		Text {
			id: algoname
			text: "Selection Sort"
			anchors.bottom: pseudoCode.top
			anchors.horizontalCenter: pseudoCode.horizontalCenter
			font {
				family: FontLoaders.algerianFont.name
				pointSize: 17
			}
		}

		Text {
			id: minLocText
			text: "i:" + i + "  j: " + j + "   min_loc:" + min_loc
			anchors.horizontalCenter: tilesRow.horizontalCenter
			font.family: "consolas"
			font.pointSize: 25
		}
	}

	Button {
		id: start_pause
		width: 130
		height: 50
		text: {
			if(!timer.running)
				return "Start"
			else
				return "Pause"
		}
		fontFamily: FontLoaders.papyrusFont.name
		boldText: true
		textSize: 15
		anchors.horizontalCenter: parent.horizontalCenter
		y: root.height - 70
		onClicked: {
			if(!sorted && tilesRow.dataArray.length === 0) {
				tilesRow.dataArray = Functions.getNRandom()
				timer.start()
			}
			else {
				timer.running ? timer.stop() : timer.start()
			}
		}
	}

	Button {
		id: oneStep
		width: 40
		height: 50
		text: "    1\nStep"
		fontFamily: FontLoaders.papyrusFont.name
		boldText: true
		textSize: 10
		anchors.left: start_pause.right
		y: start_pause.y
		onClicked: {
			timer.repeat = false
			timer.start()
		}
	}

	Drawer {
		id: drawer
		anchors.top: mainArea.bottom
		anchors.left: parent.left
		onDataInputChanged: {
			tilesRow.dataArray = drawer.dataInput
			i = j = currentLine = min_loc = 0
		}
	}

	Timer {
		id: timer
		interval: speed
		repeat: true
		onTriggered: {
			if(tilesRow.dataArray.length !== 0) {
				sorted = false

				// BEGIN SORTING

				pseudoCode.highlightLine(currentLine)

				switch(currentLine) {
				case 0:
					if(i) {
						element1.tileColor = "green"
						element2.tileColor = "green"
					}
					if(i === tileCount - 1) {
						timer.stop()
						sorted = true
						pseudoCode.highlightLine(-1)
					}
					else {
						currentLine = 2
					}
					break
				case 2:
					min_loc = i
					currentLine = 3
					break
				case 3:
					if(j) {
						element1.tileColor = "green"
						element2.tileColor = "green"
					}

					if(j === tileCount || j === 0)
						j = i + 1
					else
						j++

					if(j === tileCount)
						currentLine = 8
					else
						currentLine = 5
					break
				case 5:
					element1 = tilesRow.tileAtPos(j)
					element2 = tilesRow.tileAtPos(min_loc)
					element1.tileColor = "gray"
					element2.tileColor = "gray"

					if(element1.tileSize < element2.tileSize)
						currentLine = 6
					else
						currentLine = 3
					break
				case 6:
					min_loc = j
					currentLine = 3
					element1.tileColor = "green"
					element2.tileColor = "green"
					break
				case 8:
					element1 = tilesRow.tileAtPos(min_loc)
					element2 = tilesRow.tileAtPos(i)
					element1.tileColor = "red"
					element2.tileColor = "red"
					if(min_loc != i) {
						currentLine = 9
					}
					else {
						currentLine = 0
						i++
					}
					break
				case 9:
					tilesRow.swap(element1, element2)
					currentLine = 0
					i++
					break
				}
			}
		}
	}
}
