import QtQuick 2.3
import "../components"
import "../scripts/script.js" as Functions

Rectangle {
	id: root
	width: 720; height: 480

	property var nodes: []
	property var edges: []
	property int count: nodes.length
	property int currentPos
	property var node: Qt.createComponent("../components/Node.qml")

	Component.onCompleted: {
		nodes[0] = node.createObject(root, { "x": 100, "y": root.height/2, "value": 10 })
		nodes[0].appear.start()
	}

	Text {
		id: stateText
		text: ""
		font.pointSize: 20
		anchors.horizontalCenter: parent.horizontalCenter
		y: 100
		opacity: 0.0

		SequentialAnimation {
			id: playStateText
			running: false
			NumberAnimation { target: stateText; property: "opacity"; to: 1; duration: 300 }
			NumberAnimation { target: stateText; property: "opacity"; to: 1; duration: 2000 }
			NumberAnimation { target: stateText; property: "opacity"; to: 0; duration: 1000 }
		}
	}

	Timer {
		id: insertTimer
		interval: 400
		repeat: true
		triggeredOnStart: true
		property int step
		onTriggered: {
			var temp
			if(currentPos === nodes.length) {
				temp = node.createObject(root, {'x':nodes[currentPos-1].x+nodes[0].width+40, 'y':nodes[0].y, 'value':Math.floor(Math.random()*100+1)})
				temp.anchors.left = nodes[currentPos-1].right
				nodes[currentPos] = temp
				temp.appear.start()
				stop()
			}
			else if(currentPos === 0) {
				switch(step) {
				case 0:
					nodes[0].x += 110
					step = 1
					break
				case 1:
					temp = node.createObject(root, {'x':100, 'y':root.height/2, "value":Math.floor(Math.random()*100 + 1)})
					nodes[0].anchors.left = temp.right
					nodes.splice(0, 0, temp)
					temp.appear.start()
					step = 0
					stop()
					break
				}
			}
			else {
				switch(step) {
				case 0:
					nodes[currentPos].anchors.left = undefined
					nodes[currentPos].x += 110
					step = 1
					break
				case 1:
					temp = node.createObject(root, {'x':nodes[currentPos-1], 'y':root.height/2, 'value':Math.floor(Math.random()*100+1)})
					temp.anchors.left = nodes[currentPos-1].right
					nodes[currentPos].anchors.left = temp.right
					nodes.splice(currentPos, 0, temp)
					temp.appear.start()
					step = 0
					stop()
					break
				}
			}
		}
	}

	Timer {
		id: removeTimer
		interval: 400
		repeat: true
		triggeredOnStart: true
		property int step
		onTriggered: {
			if(currentPos === nodes.length) {
				nodes[currentPos-1].anchors.left = undefined
				nodes[currentPos-1].anchors.verticalCenter = undefined
				nodes[currentPos-1].y += 1000
				nodes.splice(currentPos-1, 1)
				step = -step+1
				stop()
			}
			else if(currentPos === 0) {
				if(step === 0) {
					nodes[1].anchors.left = undefined
					nodes[0].anchors.verticalCenter = undefined
					nodes.splice(0,1)
					step = 1
				}
				else {
					nodes[0].x -= 110
					step = 0
					stop()
					for(var i=0; i<nodes.length; i++)
						print(nodes[i].value)
				}

			}
			else {

			}
		}
	}

	Rectangle {
		id: insertButtons
		width: childrenRect.width
		height: 30
		anchors.horizontalCenter: parent.horizontalCenter

		Button {
			id: insertFirst
			width: 100
			height: parent.height
			z: 1
			text: "Insert First"
			textSize: 10
			fontFamily: FontLoaders.papyrusFont.name
			boldText: true
			onClicked: {
				currentPos = 0
				insertTimer.start()
			}
		}

		Button {
			id: insertLast
			width: 100
			height: parent.height
			z: 1
			text: "Insert Last"
			textSize: 10
			fontFamily: FontLoaders.papyrusFont.name
			boldText: true
			anchors.left: insertFirst.right
			onClicked: {
				currentPos = nodes.length
				insertTimer.start()
			}
		}

		Button {
			id: insertAt
			width: 100
			height: parent.height
			z: 1
			text: "Insert At"
			textSize: 10
			fontFamily: FontLoaders.papyrusFont.name
			boldText: true
			anchors.left: insertLast.right
			onClicked: posInputPanel.x = posInputPanel.x < 300 ? 300 : 202
		}

		Rectangle {
			id: posInputPanel
			width: 55
			height: parent.height - 4
			anchors.verticalCenter: insertButtons.verticalCenter
			x: 202
			color: "#e61c1c"
			border.color: "lightgray"
			border.width: 1

			Behavior on x {
				NumberAnimation { duration: 400; easing.type: Easing.InOutQuad }
			}

			TextInput {
				id: posInput
				x: 5
				anchors.verticalCenter: parent.verticalCenter
				cursorVisible: true
				color: "white"
				text: "1"
				selectByMouse: true
				activeFocusOnPress: true
				font.pixelSize: 14
				validator: RegExpValidator { regExp: /[0-9]{1,2}/ }
			}

			Button {
				id: goButton
				width: 40
				height: parent.height
				anchors.left: posInputPanel.right
				fontFamily: FontLoaders.papyrusFont.name
				boldText: true
				text: "Go"
				textSize: 10
				onClicked: {
					if(posInput.acceptableInput && posInput.text > 0) {
						currentPos = posInput.text - 1
						if(currentPos > nodes.length) {
							stateText.text = "Can't reach a position of %1".arg(currentPos+1)
							playStateText.start()
						}
						else {
							insertTimer.start()
						}
					}
					else {
						stateText.text = "Invalid Input!"
						playStateText.start()
					}
				}
			}
		}
	}

	Rectangle {
		id: removeButtons
		width: childrenRect.width
		height: 30
		anchors.horizontalCenter: parent.horizontalCenter
		y: insertButtons.height

		Button {
			id: removeFirst
			width: 100
			height: parent.height
			z: 1
			text: "Remove First"
			textSize: 10
			fontFamily: FontLoaders.papyrusFont.name
			boldText: true
			onClicked: {
				currentPos = 0
				removeTimer.start()
			}
		}

		Button {
			id: removeLast
			width: 100
			height: parent.height
			z: 1
			text: "Remove Last"
			textSize: 10
			fontFamily: FontLoaders.papyrusFont.name
			boldText: true
			anchors.left: removeFirst.right
			onClicked: {
				currentPos = nodes.length
				removeTimer.start()
			}
		}

		Button {
			id: removeAt
			width: 100
			height: parent.height
			z: 1
			text: "Remove At"
			textSize: 10
			fontFamily: FontLoaders.papyrusFont.name
			boldText: true
			anchors.left: removeLast.right
			onClicked: remPosInputPanel.x = remPosInputPanel.x < 300 ? 300 : 202
		}

		Rectangle {
			id: remPosInputPanel
			width: 55
			height: parent.height - 4
			anchors.verticalCenter: removeButtons.verticalCenter
			x: 202
			color: "#e61c1c"
			border.color: "lightgray"
			border.width: 1

			Behavior on x {
				NumberAnimation { duration: 400; easing.type: Easing.InOutQuad }
			}

			TextInput {
				id: remPosInput
				x: 5
				anchors.verticalCenter: parent.verticalCenter
				cursorVisible: true
				color: "white"
				text: "1"
				selectByMouse: true
				activeFocusOnPress: true
				font.pixelSize: 14
				validator: RegExpValidator { regExp: /[0-9]{1,2}/ }
			}

			Button {
				id: remGoButton
				width: 40
				height: parent.height
				anchors.left: remPosInputPanel.right
				fontFamily: FontLoaders.papyrusFont.name
				boldText: true
				text: "Go"
				textSize: 10
				onClicked: {
					if(remPosInput.acceptableInput && remPosInput.text > 0) {
						currentPos = remPosInput.text - 1
						if(currentPos > nodes.length) {
							stateText.text = "Can't reach a position of %1".arg(currentPos+1)
							playStateText.start()
						}
						else {
							removeTimer.start()
						}
					}
					else {
						stateText.text = "Invalid Input!"
						playStateText.start()
					}
				}
			}
		}
	}
}