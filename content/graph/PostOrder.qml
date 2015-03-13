import QtQuick 2.4
import "../../components"

Rectangle {
	id: root
	width: 950
	height: 640
	color: "#f9d0e4"

	property int speed: 600
	property var vertices: canvas.vertices
	property var yield: [3,4,1,9,7,8,5,6,2,0]

	VertexCanvas {
		id: canvas
	}

	Text {
		id: algoname
		text: "Post-Order Traversal"
		anchors.bottom: pseudoCode.top
		anchors.horizontalCenter: pseudoCode.horizontalCenter
		font {
			family: FontLoaders.algerianFont.name
			pointSize: 17
		}
	}

	PseudoCodeWrapper {
		id: pseudoCode
		height: 180
		anchors.right: parent.right
		anchors.verticalCenter: parent.verticalCenter
		pseudocode: [
			"1) visit left sub-tree in PostOrder",
			"2) visit right sub-tree in PostOrder",
			"3) visit root"
		]
	}
	Text {
		id: resultLabel
		text: "PostOrder Traversal: "
		opacity: 0
		font.pointSize: 17
		anchors.left: parent.left
		y: parent.height - implicitHeight

		SequentialAnimation {
			running: true
			NumberAnimation {
				target: resultLabel; property: "opacity"; to: 0; duration: 500
			}
			NumberAnimation {
				target: resultLabel; property: "opacity"; to: 1; duration: 500
			}
		}
	}

	Button {
		id: pauseButton
		width: 100
		height: 35
		text: timer.running ? "Pause" : "Start"
		fontFamily: FontLoaders.papyrusFont.name
		textSize: 17
		boldText: true
		anchors.right: restartButton.left
		anchors.top: parent.top
		onClicked: {
			if(timer.step === 0) {
				timer.reset()
				resultLabel.text = "PostOrder Traversal: "
				canvas.selectVertex(-1)
				timer.start()
			}
			else
				timer.running ? timer.stop() : timer.start()
		}
	}

	Button {
		id: restartButton
		width: 100
		height: 35
		text: "Restart"
		fontFamily: FontLoaders.papyrusFont.name
		textSize: 17
		boldText: true
		anchors.right: parent.right
		anchors.top: parent.top
		onClicked: {
			timer.reset()
			resultLabel.text = "PostOrder Traversal: "
			canvas.selectVertex(-1)
			timer.start()
		}
	}

	Timer {
		id: timer
		interval: speed
		repeat: true
		property int step
		function reset() {
			stop()
			step = 0
		}

		onTriggered: {
			switch(step) {
			case 0:
				pseudoCode.highlightLine(0)
				break
			case 1:
				canvas.selectVertex(1, false)
				break
			case 2:
				canvas.selectVertex(3, false)
				break
			case 3:
				canvas.selectVertex(3, true)
				resultLabel.text += vertices[3].label
				break
			case 4:
				canvas.selectVertex(4, false)
				break
			case 5:
				canvas.selectVertex(4, true)
				resultLabel.text += ", " + vertices[4].label
				break
			case 6:
				canvas.selectVertex(1, false)
				break
			case 7:
				canvas.selectVertex(1, true)
				resultLabel.text += ", " + vertices[1].label
				break
			case 8:
				pseudoCode.highlightLine(1)
				canvas.selectVertex(2, false)
				break
			case 9:
				canvas.selectVertex(5, false)
				break
			case 10:
				canvas.selectVertex(7, false)
				break
			case 11:
				canvas.selectVertex(9, false)
				break
			case 12:
				canvas.selectVertex(9, true)
				resultLabel.text += ", " + vertices[9].label
				break
			case 13:
				canvas.selectVertex(7, false)
				break
			case 14:
				canvas.selectVertex(7, true)
				resultLabel.text += ", " + vertices[7].label
				break
			case 15:
				canvas.selectVertex(8, false)
				break
			case 16:
				canvas.selectVertex(8, true)
				resultLabel.text += ", " + vertices[8].label
				break
			case 17:
				canvas.selectVertex(5, false)
				break
			case 18:
				canvas.selectVertex(5, true)
				resultLabel.text += ", " + vertices[5].label
				break
			case 19:
				canvas.selectVertex(6, false)
				break
			case 20:
				canvas.selectVertex(6, true)
				resultLabel.text += ", " + vertices[6].label
				break
			case 21:
				canvas.selectVertex(2, false)
				break
			case 22:
				canvas.selectVertex(2, true)
				resultLabel.text += ", " + vertices[2].label
				break
			case 23:
				pseudoCode.highlightLine(2)
				canvas.selectVertex(0, false)
				break
			case 24:
				canvas.selectVertex(0, true)
				resultLabel.text += ", " + vertices[0].label
				break
			}
			if(step === 24) {
				pseudoCode.highlightLine(-1)
				reset()
			}
			else
				step++
		}
	}
}
