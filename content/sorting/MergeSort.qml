import QtQuick 2.0
import "../../components"
import "../../scripts/script.js" as Functions

Rectangle {
	id: root

	width: 1200
	height: 660
	color: "#e66e7c"

	property alias tileCount: tilesRow.tileCount
	property bool sorted: false
	property bool debug

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
			height: 450
			width: 430
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
					return "w: " + timer.w + "   i: " + timer.i
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

	BottomPanel {
		id: controlPanel
		sliderMaxVal: 1900
		sliderMinVal: 0
		sliderValue: 1500
		sliderColor: root.color
	}

	Timer {
		id: timer
		interval: controlPanel.sliderMaxVal - controlPanel.sliderValue + 100
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
		property bool mergeSortInnerInitial
		property bool mergeLoopInitial

		function reset() {
			stop()
			currentLine = w = lStart = rStart = end = l = r = i = j = 0
			leftElement = rightElement = null
			pseudoCode.highlightLine(-1)
		}

		onTriggered: {
			if(tilesRow.dataArray.length !== 0) {
				sorted = false

				pseudoCode.highlightLine(currentLine)

				switch(currentLine) {
				case 0:
					currentLine = 2
					break

				case 2:
					w = (w === 0) ? 1 : (2 * w)
					currentLine = (w < tileCount) ? 4 : 7
					mergeSortInnerInitial = true
					break

				case 4:
					if(mergeSortInnerInitial) {
						i = 0
						mergeSortInnerInitial = false
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
					var y, p, temp
					y = tilesRow.tileAtPos(0).y
					for(p=0; p<tileCount; p++) {
						temp = tilesRow.tileAtXY(p * 55, y)
						temp.pos = p
						temp.y += 150
					}
					currentLine = 2
					break

				case 7:
					currentLine = 8
					break

				case 8:
					sorted = true
					stop()
					currentLine = -1
					pseudoCode.highlightLine(-1)
					break

				case 10:
					lStart = i
					rStart = Math.min(i+w, tileCount)
					end = Math.min(i+2*w, tileCount)
					tilesRow.highlightTile(lStart, end-1)
					currentLine = 12
					break

				case 12:
					l = lStart
					r = rStart
					currentLine = 13
					mergeLoopInitial = true
					break

				case 13:
					if(mergeLoopInitial) {
						j = l
						mergeLoopInitial = false
					}
					else {
						j++
					}
					currentLine = (j < end) ? 15 : 21
					break

				case 15:
					if(l < rStart && (r >= end || tilesRow.tileAtPos(l).tileSize <= tilesRow.tileAtPos(r).tileSize)) {
						currentLine = 16
					}
					else
						currentLine = 18
					break

				case 16:
					tilesRow.moveToPos(tilesRow.tileAtPos(l), j, -150)
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
					tilesRow.moveToPos(tilesRow.tileAtPos(r), j, -150)
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
					tilesRow.highlightTile(-1)
					break

				default:
					reset()
				}
			}
			if(debug) {
				print("w:", w, " i:", i)
				print("LStart:", lStart, " RStart:", rStart, " End:", end)
				print("L:", l, " R:", r, " j:", j)
			}
		}
	}
	onSortedChanged: {
		if(sorted && debug) {
			print("\nTiles:")
			for(y=0; y<tileCount; y++)
				print(tilesRow.tileAtPos(y).tileSize)
			print("\n")
		}
	}
}
