import QtQuick 2.0
import "../components"
import "../scripts/script.js" as Functions

Rectangle {
	id: root

	width: 892
	height: 560
	color: "#7185e8"

	property int speed: 200	// minimum safe value is 200, more causes tiles to be misplaced
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
		width: 892; height: 500
		color: "transparent"

		TilesWrapper {
			id: tilesRow
			dataArray: Functions.getNRandom()
			anchors.verticalCenter: parent.verticalCenter
		}

		PseudoCodeWrapper {
			id: pseudoCode
			height: 180
			anchors.left: tilesRow.right
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
				family: "algerian"
				pointSize: 17
			}
		}

		Text {
			id: varValuesText
			text: "i:" + i + "  j:" + j + "  currentLine:" + currentLine
			anchors.horizontalCenter: tilesRow.horizontalCenter
			font.family: "cosolas"
			font.pointSize: 25
		}
	}

	Drawer {
		id: drawer
		anchors.top: mainArea.bottom
		anchors.left: parent.left
		onDataInputChanged: {
			tilesRow.dataArray = drawer.dataInput
			i = 1
			j = currentLine =  0
			print("data changed")
		}
	}

	FontLoader { id: papyrusFont; source: "../fonts/Papyrus.ttf" }

	Button {
		width: 130
		height: 50
		text: timer.running ? "Pause" : "Start"
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


	Timer {
		id: timer
		interval: speed
		repeat: true
		triggeredOnStart: true
		onTriggered: {
			if(tilesRow.dataArray.length !== 0) {
				sorted = false

				// BEGIN SORTING

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





//for(i=1; i<N; i++)
//	j = i;
//	temp = arr[i];
//	while(j>0 && arr[j-1]>temp)
//		arr[j] = arr[j-1];
//		j--;
//	arr[j] = temp;
