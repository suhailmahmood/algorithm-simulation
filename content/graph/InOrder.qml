import QtQuick 2.4
import "../../components"

Rectangle {
	id: root
	width: 720
	height: 640
	color: "#f9d0e4"

	property int speed: 600
	property var vertices: canvas.vertices
	property var yield: [3,1,4,0,9,7,5,8,2,6]

	VertexCanvas {
		id: canvas
	}

	Text {
		id: resultLabel
		text: ""
		opacity: 0
		font.pointSize: 20
		anchors.horizontalCenter: parent.horizontalCenter
		y: parent.height - implicitHeight
		Behavior on opacity {
			NumberAnimation {
				target: resultLabel
				property: "opacity"
				duration: 600
				easing.type: Easing.InOutQuad
			}
		}
		function showResult() {
			text = "InOrder Traversal yield: "
			for(var i=0; i<yield.length; i++) {
				text += vertices[yield[i]].label
				if(i !== yield.length - 1)
					text += ", "
			}
			opacity = 1
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
			resultLabel.text = ""
			resultLabel.opacity = 0
			canvas.selectVertex(-1)
			timer.start()
		}
	}

	Timer {
		id: timer
		interval: speed
		repeat: true
		running: true
		property int step
		function reset() {
			stop()
			step = 0
		}

		onTriggered: {
			switch(step) {
			case 0:
				canvas.selectVertex(0, false)
				break
			case 1:
				canvas.selectVertex(1, false)
				break
			case 2:
				canvas.selectVertex(3, false)
				break
			case 3:
				canvas.selectVertex(3, true)
				break
			case 4:
				canvas.selectVertex(1, false)
				break
			case 5:
				canvas.selectVertex(1, true)
				break
			case 6:
				canvas.selectVertex(4, false)
				break
			case 7:
				canvas.selectVertex(4, true)
				break
			case 8:
				canvas.selectVertex(0, false)
				break
			case 9:
				canvas.selectVertex(0, true)
				break
			case 10:
				canvas.selectVertex(2, false)
				break
			case 11:
				canvas.selectVertex(5, false)
				break
			case 12:
				canvas.selectVertex(7, false)
				break
			case 13:
				canvas.selectVertex(9, false)
				break
			case 14:
				canvas.selectVertex(9, true)
				break
			case 15:
				canvas.selectVertex(7, false)
				break
			case 16:
				canvas.selectVertex(7, true)
				break
			case 17:
				canvas.selectVertex(5, false)
				break
			case 18:
				canvas.selectVertex(5, true)
				break
			case 19:
				canvas.selectVertex(8, false)
				break
			case 20:
				canvas.selectVertex(8, true)
				break
			case 21:
				canvas.selectVertex(2, false)
				break
			case 22:
				canvas.selectVertex(2, true)
				break
			case 23:
				canvas.selectVertex(6, false)
				break
			case 24:
				canvas.selectVertex(6, true)
				break
			}
			if(step === 24) {
				reset()
				resultLabel.showResult()
			}
			else
				step++
		}
	}
}
