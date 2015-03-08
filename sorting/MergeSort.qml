import QtQuick 2.0
import "../components"
import "../scripts/script.js" as Functions

Rectangle {
	id: root

	width: 1200
	height: 660
	color: "#f18912"

	property int speed: 500 // speed as low as 50 still works
	property alias tileCount: tilesRow.tileCount
	property bool sorted: false

	Rectangle {
		id: mainArea
		anchors.centerIn: parent
		width: root.width
		height: 300
		color: "transparent"

		TilesWrapper {
			id: tilesRow
			height: 500
			width: root.width - pseudoCode.width
			anchors.verticalCenter: parent.verticalCenter
		}

		PseudoCodeWrapper {
			id: pseudoCode
			height: 420
			width: 430
			textSize: 10
			anchors.right: mainArea.right
			anchors.verticalCenter: parent.verticalCenter
			pseudocode: [


"MergeSort():",
"{",
"  for(w=1; w<n; w=2*w)",
"  {",
"    for(i=0; i<n; i=i+2*w)",
"      Merge(i, min(i+w, n), min(i+2*w, n))",
"    copyToOriginalArray()",
"  }",
"}",
" ",
"Merge(LStart, RStart, End):",
"{",
"  L=LStart, R=RStart",
"  for(j=L; j<End; j++)",
"  {",
"    if(L<RStart and (R>=End or ARR[L]<=ARR[R]))",
"      WORK[j] = ARR[L]",
"      L = L + 1",
"    else",
"      WORK[j] = ARR[R]",
"      R = R + 1",
"  }",
"}"
			]
		}

		Text {
			id: algoname
			text: "Merge Sort"
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
			anchors.top: tilesRow.top
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
			timer.reset()
		}
	}

	Timer {
		id: timer
		interval: speed
		repeat: true
		property var element1
		property var element2
		property int currentLine
		property int width
		property int lStart
		property int rStart
		property int end
		property int l
		property int r
		property int i
		property int j

		function reset() {
			stop()
			currentLine = width = lStart = rStart = end = l = r = 0
			element1 = element2 = null
		}

		onTriggered: {
			if(tilesRow.dataArray.length !== 0) {
				sorted = false

				// BEGIN SORTING

				pseudoCode.highlightLine(currentLine)

				switch(currentLine) {
				case 0:
					currentLine = 2
					break

				case 2:
					width = (width === 0) ? 1 : (2 * width)
					currentLine = (width < tileCount) ? 4 : 7
					break

				case 4:
					i = (i === 0) ? 0 : (i + 2 * width)
					currentLine = (i < tileCount) ? 5 : 6
					break
				case 5:
					currentLine = 10

					break
				case 6:
					break
				case 7:
					currentLine = 8
					break
				case 8:
					sorted = true
					stop()
					currentLine = -1
					break
				case 10:
					lStart = Math.min(i+width, tileCount)
					rStart = Math.min(i+2*width, tileCount)
					currentLine = 12
					break
				case 12:
					l = lStart
					r = rStart
					currentLine = 13
					break
				case 13:
					// run tests to verify that condition in 1st line holds
					j = (l === lStart && r === rStart) ? l : j + 1
					currentLine = (j < end) ? 15 : 21
					break
				case 15:
					element1 = tilesRow.tileAtPos(l)
					element2 = tilesRow.tileAtPos(r)
					if(l < rStart && (element1.tileSize <= element2.tileSize))
						currentLine = 16
					else
						currentLine = 18
					break
				case 16:
					// copy element1 to WORK array at position j
					currentLine = 17
					break
				case 17:
					l++
					currentLine = 13
					break
				case 18:
					currentLine = 19
					break
				case 19:
					// copy element2 to WORK array at position j
					currentLine = 20
					break
				case 20:
					currentLine = 13
					break
				case 21:
					currentLine = 22
					break
				case 22:
					currentLine = 4
				}
			}
		}
	}
}
