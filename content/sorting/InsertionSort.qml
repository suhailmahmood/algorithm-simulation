import QtQuick 2.0
import "../../components"
import "../../scripts/script.js" as Functions

Rectangle {
	id: root

	width: 1200
	height: 660
	color: "#1cc1e6"

	property int i:1
	property int j
	property alias tileCount: tilesRow.tileCount
	property var temp
	property var element2
	property int currentLine
	property bool sorted: false

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
			height: 180
			anchors.right: mainArea.right
			anchors.verticalCenter: parent.verticalCenter
			pseudocode: [
				"for (i=2 to n)",
				"  j = i",
				"  temp = array[i]",
				"  while (j > 1 and array[j-1] > temp)",
				"    array[j] = array[j-1]",
				"    j = j - 1",
				"  array[j] = temp"
			]
		}

		Text {
			id: algoname
			text: "Insertion Sort"
			anchors.bottom: pseudoCode.top
			anchors.horizontalCenter: pseudoCode.horizontalCenter
			font {
				family: FontLoaders.algerianFont.name
				pointSize: 17
			}
		}

		Text {
			id: varValuesText
			text: "i: " + i + "   j: " + j
			anchors.horizontalCenter: tilesRow.horizontalCenter
			anchors.bottom: mainArea.top
			font.family: "consolas"
			font.pointSize: 25
		}
	}

	BottomPanel {
		id: controlPanel
		sliderMaxVal: 1900
		sliderMinVal: 0
		sliderValue: 1500
		sliderColor: root.color
	}

	Timer {
		id: timer
		interval: controlPanel.sliderMaxVal - controlPanel.sliderValue + 200
		repeat: true

		function reset() {
			stop()
			i = 1
			j = currentLine =  0
		}

		onTriggered: {
			if(tilesRow.dataArray.length !== 0) {
				sorted = false

				pseudoCode.highlightLine(currentLine)

				switch(currentLine) {
				case 0:
					if(i > 1) {
						temp.tileColor = "green"
					}
					if(i < tileCount) {
						currentLine = 1
					}
					else {
						sorted = true
						stop()
						pseudoCode.highlightLine(-1)
					}
					break

				case 1:
					j = i
					currentLine = 2
					break

				case 2:
					temp = tilesRow.tileAtPos(i)
					temp.y -= 150
					temp.tileColor = "red"
					currentLine = 3
					break

				case 3:
					if (j > 0) {
						element2 = tilesRow.tileAtPos(j-1)
						element2.tileColor = "gray"
						currentLine = element2.tileSize > temp.tileSize ? 4 : 6
					}
					else {
						currentLine = 6
					}
					break

				case 4:
					tilesRow.swap(tilesRow.tileAtPos(j), element2)
					element2.tileColor = "green"
					currentLine = 5
					break

				case 5:
					j--
					currentLine = 3
					break

				case 6:
					element2.tileColor = "green"
					tilesRow.tileAtPos(j).y += 150
					i++
					currentLine = 0
				}
			}
		}
	}
}