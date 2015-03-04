import QtQuick 2.0
import "../components"
import "../scripts/script.js" as Functions

Rectangle {
	id: root

	width: 892
	height: 360
	color: "#f18912"

	property int speed: 100 // speed as low as 50 still works
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
			dataArray: Functions.getNRandom()
			anchors.verticalCenter: parent.verticalCenter
		}

		Text {
			id: algoname
			text: "Selection Sort"
			anchors.bottom: pseudoCode.top
			anchors.horizontalCenter: pseudoCode.horizontalCenter
			font {
				family: "algerian"
				pointSize: 17
			}
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
			id: minLocText
			text: "i:" + i + "  j: " + j + "   min_loc:" + min_loc
			anchors.horizontalCenter: tilesRow.horizontalCenter
			font.family: "consolas"
			font.pixelSize: 30
		}

	}

	FontLoader { id: papyrusFont; source: "../fonts/Papyrus.ttf" }

	Button {
		width: 130
		height: 50
		text: {
			if(!timer.running)
				return "Start"
			else
				return "Pause"
		}
		fontFamily: papyrusFont.name
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

	Drawer {
		id: drawerBubble
		anchors.top: mainArea.bottom
		anchors.left: parent.left
		onDataInputChanged: {
			tilesRow.dataArray = drawerBubble.dataInput
			i = j = currentLine = min_loc = 0
			print("data changed")
		}
	}

	Timer {
		id: timer
		interval: speed
		repeat: true
		triggeredOnStart: true
		property bool selectTilePhase: true
		onTriggered: {
			if(tilesRow.dataArray.length !== 0) {
				sorted = false
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
	onSortedChanged: sorted ? "Sorted" : "Not sorted"
}
