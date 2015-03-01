import QtQuick 2.0
import "../components"
import "../scripts/script.js" as Functions

Rectangle {
	id: bubble

	width: mainArea.width
	height: mainArea.height+100
	color: "#7185e8"

	property int speed: 500	// minimum safe value is 120, more cause tiles to be misplaced
	property int i
	property int j
	property alias tileCount: tilesRow.tileCount
	property var element1
	property var element2
	property int currentLine

	Rectangle {
		id: mainArea
		anchors.centerIn: parent
		width: 892
		height: 300
		color: "#ec7a0f"

		TilesWrapper {
			id: tilesRow
			dataArray: Functions.getNRandom(10)
			anchors.verticalCenter: parent.verticalCenter
		}

		PseudoCodeWrapper {
			id: pseudoCode
			anchors.left: tilesRow.right
			anchors.verticalCenter: parent.verticalCenter
			pseudocode: [
				"for (i=1 to n-1)",
				"  for (j=1 to n-i-1)",
				"    if (array[j] > array[j+1])",
				"      swap(array[j], array[j+1])"
			]
		}
	}

	Drawer {
		id: drawerBubble
		anchors.top: mainArea.bottom
		anchors.left: parent.left
		onDataInputChanged: {
			tilesRow.dataArray = drawerBubble.dataInput
			i = j = currentLine = 0
			for(var p=0; p<3; p++)
				start_pause.timers[p].stop()
		}
	}

	Component.onCompleted: print(tileCount)

	// 3 Timers and the MouseArea below

	MouseArea {
		id: start_pause
		anchors.fill: mainArea
		property var timers: [codeSelectTimer, sortTimer, sleeper]
		property int runningTimer: -1
		onClicked: {
			if(timers[0].running || timers[1].running || timers[2].running) {

				if(timers[0].running)
					runningTimer = 0

				else if(timers[1].running)
					runningTimer = 1

				else if(timers[2].running)
					runningTimer = 2

				timers[runningTimer].stop()
			}
			else if(runningTimer === -1) {
				codeSelectTimer.start()
			}
			else {
				timers[runningTimer].start()
			}
		}
	}

	Timer {
		id:codeSelectTimer
		interval: speed * 1.33
		running: false
		repeat: true
		triggeredOnStart: true
		onTriggered: {
			// when currentLine is 3rd line, send control to sortTimer
			if(currentLine === 2) {
				stop()
				sortTimer.start()
			}
			pseudoCode.highlightLine(currentLine)
			currentLine++
		}
	}

	Timer {
		id: sortTimer
		interval: speed * 1.33
		repeat: true
		triggeredOnStart: true
		property bool selectTilePhase: true
		onTriggered: {
			if(selectTilePhase) {
				element1 = tilesRow.tileAtPos(j)
				element2 = tilesRow.tileAtPos(j + 1)
				element1.color = "gray"
				element2.color = "gray"

				selectTilePhase = false
			}
			else {
				selectTilePhase = true
				if (parseInt(element1.tileLabel) > parseInt(element2.tileLabel)) {
					pseudoCode.highlightLine(3)
					tilesRow.swap(element1, element2)
				}
				sleeper.start()
				j++
				if(j === tileCount-i-1) {
					i++
					j = 0
					currentLine = 0
				}
				else {
					currentLine = 1
				}
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
			if(i === tileCount-1) {
				codeSelectTimer.stop()
				pseudoCode.highlightLine(-1)
			}
			else {
				codeSelectTimer.start()
			}
		}
	}
}
