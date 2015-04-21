import QtQuick 2.4
import "../../components"
import "../../scripts/script.js" as Functions

Rectangle {
	id: root

	width: 1200
	height: 660
	color: "#7185e8"

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
		width: root.width
		height: 450
		color: "transparent"

		TilesWrapper {
			id: tilesRow
			anchors.verticalCenter: parent.verticalCenter
			height: parent.height / 2
			width: root.width - pseudoCode.width
			anchors.bottom: mainArea.bottom
		}

		PseudoCodeWrapper {
			id: pseudoCode
			height: 170
			anchors.right: mainArea.right
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
			text: "n:" + tileCount + "  i:" + (i + 1) + "  j:" + (j + 1)
			anchors.horizontalCenter: tilesRow.horizontalCenter
			anchors.bottom: mainArea.top
			font {
				family: "consolas"
				pointSize: 25
			}
		}
	}

	BottomPanel {
		id: controlPanel
		sliderMaxVal: 1800
		sliderMinVal: 0
		sliderValue: 1500
		sliderColor: root.color
	}

	Timer {
		id: timer
		interval: controlPanel.sliderMaxVal - controlPanel.sliderValue + 200
		repeat: true
		property bool innerLoopBegin: true
		property bool initial: true

		function reset() {
			stop()
			initial = innerLoopBegin = repeat = true
			sorted = false
			i = j = currentLine = 0
		}

		onTriggered: {
			if (tilesRow.dataArray.length !== 0) {
				sorted = false

				pseudoCode.highlightLine(currentLine)

				switch (currentLine) {
				case (0):
					if (i === tileCount - 1) {
						stop()
						initial = true
						currentLine = -1
						sorted = true
					} else {
						i = initial ? i : i + 1
						currentLine = 1
					}
					break
				case (1):
					if (!initial) {
						element1.tileColor = "green"
						element2.tileColor = "green"
					}
					initial = false

					j = innerLoopBegin ? 0 : j + 1
					if (j === tileCount - i - 1) {
						currentLine = 0
						innerLoopBegin = true
					} else {
						currentLine = 2
					}
					break
				case (2):
					element1 = tilesRow.tileAtPos(j)
					element2 = tilesRow.tileAtPos(j + 1)
					element1.tileColor = "gray"
					element2.tileColor = "gray"
					innerLoopBegin = false

					if (element1.tileSize > element2.tileSize) {
						currentLine = 3
					} else {
						currentLine = 1
					}
					break
				case (3):
					tilesRow.swap(element1, element2)
					currentLine = 1
					break
				}
			}
		}
	}
}
