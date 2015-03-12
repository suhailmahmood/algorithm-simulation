import QtQuick 2.0
import "../components"
import "../scripts/script.js" as Functions

Rectangle {
	id: root

	width: mainArea.width
	height: mainArea.height+60
	color: "#7185e8"

	property int speed: 300	// minimum safe value is 120, more cause tiles to be misplaced
	property int i
	property int j
	property alias tileCount: tilesRow.tileCount
	property var element1
	property var element2
	property int currentLine
	property bool sorted

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
			height: 170
			anchors.left: tilesRow.right
			anchors.verticalCenter: parent.verticalCenter
			pseudocode: [
				"for (i=1 to n-1)",
				"  for (j=1 to n-i)",
				"    if (array[j] > array[j+1])",
				"      swap(array[j], array[j+1])"
			]
		}

		Text {
			id: algoname
			text: "Bubble Sort"
			anchors.bottom: pseudoCode.top
			anchors.horizontalCenter: pseudoCode.horizontalCenter
			font {
				family: FontLoaders.algerianFont.name
				pointSize: 17
			}
		}

		Text {
			id: ijValText
			text: "n:" + tileCount + "  i:" + (i+1) + "  j:" + (j+1)
			anchors.horizontalCenter: tilesRow.horizontalCenter
			font {
				family: FontLoaders.papyrusFont.name
				pointSize: 25
			}
		}
	}

	Drawer {
		id: drawer
		anchors.top: mainArea.bottom
		anchors.left: parent.left
		onDataInputChanged: {
			tilesRow.dataArray = drawer.dataInput
			timer.stop()
			timer.reset()
		}
	}

	Button {
		id: start_pause
		width: 120
		height: 50
		text: timer.running ? "Pause" : "Start"
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
			else if(sorted && !timer.running) {
				tilesRow.dataArray = Functions.getNRandom()
				timer.reset()
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

	Timer {
		id: timer
		interval: speed
		repeat: true
		property bool innerLoopBegin: true
		property bool initial: true

		function reset() {
			initial = innerLoopBegin = true
			sorted = false
			i = j = 0
		}

		onTriggered: {
			if(tilesRow.dataArray.length !== 0) {
				sorted = false

				// BEGIN SORTING

				pseudoCode.highlightLine(currentLine)

				switch(currentLine) {
				case(0):
					if(i === tileCount-1) {
						stop()
						initial = true
						currentLine = -1
						sorted = true
					}
					else {
						i = initial ? i : i+1
						currentLine = 1
					}
					break

				case(1):
					if(!initial) {
						element1.tileColor = "green"
						element2.tileColor = "green"
					}
					initial = false

					j = innerLoopBegin ? 0 : j + 1
					if(j === tileCount-i-1) {
						currentLine = 0
						innerLoopBegin = true
					}
					else {
						currentLine = 2
					}
					break

				case(2):
					element1 = tilesRow.tileAtPos(j)
					element2 = tilesRow.tileAtPos(j+1)
					element1.tileColor = "gray"
					element2.tileColor = "gray"
					innerLoopBegin = false

					if (element1.tileSize > element2.tileSize) {
						currentLine = 3
					}
					else {
						currentLine = 1
					}
					break
				case(3):
					tilesRow.swap(element1, element2)
					currentLine = 1
					break
				}
			}
		}
	}
}
