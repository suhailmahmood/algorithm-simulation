import QtQuick 2.0
import "../components"
import "../scripts/script.js" as Functions

Rectangle {
	id: root

	width: 1200
	height: 660
	color: "#f18912"

	property int speed: 500
	property alias tileCount: tilesRow.tileCount
	property bool sorted: false
	property var bArray: []
	property var aArray: []

	Rectangle {
		id: mainArea
		anchors.centerIn: parent
		width: root.width
		height: 450
		color: "transparent"

		TilesWrapper {
			id: tilesRow
//			color: "green"
			height: parent.height / 2
			width: root.width - pseudoCode.width
			anchors.bottom: mainArea.bottom
		}

		PseudoCodeWrapper {
			id: pseudoCode
			height: 450
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
			id: helpText
			text: {
				if(timer.currentLine < 10)
					return "w: " + timer.w + "\ni: " + timer.i
				else
					return "LStart:" + timer.lStart +" RStart:" + timer.rStart + " End:" + timer.end +
							"\nL:" + timer.l + " R:" + timer.r + " j:" + timer.j
			}
			anchors.horizontalCenter: tilesRow.horizontalCenter
			anchors.bottom: mainArea.top
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

			//		delete after testing
			for(var k=0; k<tileCount; k++) {
				aArray[k] = tilesRow.tileAtPos(k).tileSize
			}
			//		delete after testing
		}
	}

	Timer {
		id: timer
		interval: 500
		repeat: true
		property var leftElement
		property var rightElement
		property int currentLine
		property int w
		property int lStart
		property int rStart
		property int end
		property int l
		property int r
		property int i
		property int j
		property bool mergeInnerInitial

		function reset() {
			stop()
			currentLine = w = lStart = rStart = end = l = r = i = j = 0
			leftElement = rightElement = null
		}

		onTriggered: {
			print("\nCurrentLine", currentLine)

			if(tilesRow.dataArray.length !== 0) {
				sorted = false

				// BEGIN SORTING

				pseudoCode.highlightLine(currentLine)

				switch(currentLine) {
				case 0:
					currentLine = 2
					break

				case 2:
					w = (w === 0) ? 1 : (2 * w)
					currentLine = (w < tileCount) ? 4 : 7
					mergeInnerInitial = true
					break

				case 4:
					// end is non-zero after first run of the inner loop of MergeSort
					if(mergeInnerInitial) {
						i = 0
						mergeInnerInitial = false
					}
					else {
						i = i + 2 * w
					}

					currentLine = (i < tileCount) ? 5 : 6
					break
				case 5:
					currentLine = 10
					break
				case 6:
					for(var p=0; p<tileCount; p++)
						aArray[p] = bArray[p]
					currentLine = 2
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
					lStart = i
					rStart = Math.min(i+w, tileCount)
					end = Math.min(i+2*w, tileCount)
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
					leftElement = aArray[l]
					rightElement = aArray[r]
					//					leftElement = tilesRow.tileAtPos(l)
					//					rightElement = tilesRow.tileAtPos(r)
					if(l < rStart && (r >= end || leftElement <= rightElement))
						currentLine = 16
					else
						currentLine = 18
					break
				case 16:
					bArray[j] = aArray[l]
					// copy leftElement to WORK array at position j
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
					bArray[j] = aArray[r]
					// copy rightElement to WORK array at position j
					currentLine = 20
					break
				case 20:
					r++
					currentLine = 13
					break
				case 21:
					currentLine = 22
					break
				case 22:
					currentLine = 4
				}
			}
			print("w:", w, " i:", i)
			print("LStart:", lStart, " RStart:", rStart, " End:", end)
			print("L:", l, " R:", r, " j:", j)
		}
	}
	onSortedChanged: {
		if(sorted)
			for(var y=0; y<tileCount; y++)
				print(aArray[y])
	}
}
