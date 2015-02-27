import QtQuick 2.0
import "../components"

Rectangle {
	id: selection

	width: 892
	height: 300
	color: "#7185e8"
	radius: 10

	property int speed: 500 // a value less that 150 is problematic
	property int i
	property int j: i + 1
	property int min_loc: -1
	property alias tileCount: tilesRow.tileCount
	property var element1
	property var element2
	property int currentLine

	MouseArea {
		id: start_pause
		anchors.fill: parent
		property var timers: [outerLoopTimer, innerLoopTimer, lastSwapTimer, sleeper]
		property int runningTimer: -1
		onClicked: {
			if (timers[0].running || timers[1].running || timers[2].running
					|| timers[3].running) {

				if (timers[0].running)
					runningTimer = 0
				else if (timers[1].running)
					runningTimer = 1
				else if (timers[2].running)
					runningTimer = 2
				else if (timers[3].running)
					runningTimer = 3

				timers[runningTimer].stop()
			} else if (runningTimer === -1) {
				outerLoopTimer.start()
			} else {
				timers[runningTimer].start()
			}
		}
	}

	TilesWrapper {
		id: tilesRow
		anchors.verticalCenter: parent.verticalCenter
	}

	PseudoCodeWrapper {
		id: pseudoCode
		anchors.left: tilesRow.right
		anchors.verticalCenter: parent.verticalCenter
		pseudocode: [
			"for (i=1 to n-1)",
			"{",
			"   min_loc = i",
			"   for (j=i+1 to n)",
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
		id: minloc
		text: "i:" + (i + 1) + "   min_loc:" + ((min_loc === -1) ? "" : (min_loc + 1))
		anchors.horizontalCenter: tilesRow.horizontalCenter
		y: 50
		font.family: "consolas"
		font.pixelSize: 30
	}

	Timer {
		id: outerLoopTimer
		interval: speed * 1.33
		running: false
		repeat: true
		triggeredOnStart: true
		onTriggered: {
			pseudoCode.highlightLine(currentLine)
			if (currentLine === 0 || currentLine === 3) {
				currentLine += 2
			} else if (currentLine === 2) {
				min_loc = i
				currentLine++
			} else if (currentLine === 5) {
				stop()
				innerLoopTimer.start()
			} else if (currentLine === 8) {
				stop()
				lastSwapTimer.start()
			}
		}
	}

	Timer {
		id: innerLoopTimer
		interval: speed * 1.33
		repeat: true
		triggeredOnStart: true
		property bool selectTilePhase: true
		onTriggered: {
			if (selectTilePhase) {
				element1 = tilesRow.tileAtPos(j)
				element2 = tilesRow.tileAtPos(min_loc)
				element1.color = "gray"
				element2.color = "gray"

				selectTilePhase = false
			}
			else {
				selectTilePhase = true
				if (parseInt(element1.tileLabel) < parseInt(element2.tileLabel)) {
					pseudoCode.highlightLine(6)
					min_loc = j
				}
				sleeper.start()
				j++
				if (j === tileCount) {
					currentLine = 8
				} else {
					currentLine = 3
				}
				stop()
			}
		}
	}

	Timer {
		id: lastSwapTimer
		interval: speed * 1.33
		repeat: true
		property bool selectTilePhase: true
		onTriggered: {
			if (selectTilePhase) {
				element1 = tilesRow.tileAtPos(min_loc)
				element2 = tilesRow.tileAtPos(i)
				element1.color = "red"
				element2.color = "red"
				selectTilePhase = false
			}
			else {
				selectTilePhase = true
				if (min_loc !== i) {
					pseudoCode.highlightLine(9)
					tilesRow.swap(element1, element2)
				}
				i++
				j = i + 1
				sleeper.start()
				currentLine = 0
				stop()
			}
		}
	}

	Timer {
		id: sleeper
		interval: speed
		repeat: false
		onTriggered: {
			element1.color = "green"
			element2.color = "green"
			if (i === tileCount - 1) {
				outerLoopTimer.stop()
				pseudoCode.highlightLine(-1)
			}
			else {
				outerLoopTimer.start()
			}
		}
	}
}
