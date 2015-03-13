import QtQuick 2.3
import "../../components"
import "../../scripts/script.js" as Functions

Rectangle {
	id: root
	width: 720; height: 480
	color: "#888972ee"

	property var nodes: []
	property var edges: []
	property int count: nodes.length
	property int currentIndex
	property var node: Qt.createComponent("../../components/Node.qml")
	property var edge: Qt.createComponent("../../components/Edge.qml")

	Component.onCompleted: {
		nodes[0] = node.createObject(root, { "x": 100, "y": root.height/2, "value": 10 })
		nodes[0].appear.start()
	}

	Text {
		id: name
		text: "Linked List"
		y: removeButtons.y + removeButtons.height + 30
		anchors.horizontalCenter: parent.horizontalCenter
		font {
			family: FontLoaders.algerianFont.name
			pointSize: 17
		}
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
			// insert first
			if(currentIndex === 0) {

				// list is empty
				if(nodes.length === 0) {
					nodes[0] = node.createObject(root, {'x':100, "value":Math.floor(Math.random()*100 + 1)})
					nodes[0].appear.start()
					stop()
				}

				// list is non-empty, so move current first node in x direction by 110, then insert
				else {
					switch(step) {
					case 0:
						nodes[0].x += 110
						step = 1
						break
					case 1:
						temp = node.createObject(root, {'x':100, "value":Math.floor(Math.random()*100 + 1)})
						nodes[0].anchors.left = temp.right
						temp.appear.start()
						nodes.splice(0, 0, temp)
						step = 0
						stop()
						break
					}
				}
			}

			// insert last, currentPos is not zero
			else if(currentIndex === nodes.length) {
				// using nodes[0] for default width value, y value
				temp = node.createObject(root, {'value':Math.floor(Math.random()*100+1)})
				temp.anchors.left = nodes[currentIndex-1].right
				temp.appear.start()
				nodes[currentIndex] = temp
				stop()
			}
			else {
				switch(step) {
				case 0:
					nodes[currentIndex].anchors.left = undefined
					nodes[currentIndex].x += 110
					step = 1
					break
				case 1:
					temp = node.createObject(root, {'value':Math.floor(Math.random()*100+1)})
					temp.anchors.left = nodes[currentIndex-1].right
					nodes[currentIndex].anchors.left = temp.right
					temp.appear.start()
					nodes.splice(currentIndex, 0, temp)
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
			// remove first
			if(currentIndex === 0) {
				if(nodes.length === 0) {
					stateText.text = "Linked List empty!"
					playStateText.start()
					stop()
				}
				else {
					switch(step) {
					case 0:
						if(nodes.length > 1)
							nodes[1].anchors.left = undefined

						nodes[0].anchors.verticalCenter = undefined
						nodes[0].y += 1000
						nodes.splice(0,1)

						if(nodes.length)
							step = 1
						else
							stop()
						break
					case 1:
						nodes[0].x -= 110
						step = 0
						stop()
					}
				}
			}

			// remove last
			else if(currentIndex === nodes.length - 1 && step === 0) {
				nodes[currentIndex].anchors.left = undefined
				nodes[currentIndex].anchors.verticalCenter = undefined
				nodes[currentIndex].y += 1000
				nodes.splice(currentIndex, 1)
				stop()
			}

			// remove node at currentIndex
			else {
				switch(step) {
				case 0:
					nodes[currentIndex].anchors.left = undefined
					nodes[currentIndex].anchors.verticalCenter = undefined
					nodes[currentIndex+1].anchors.left = undefined
					nodes[currentIndex].y += 1000
					step = 1
					break
				case 1:
					nodes.splice(currentIndex, 1)
					nodes[currentIndex].x -= 110
					// now at currentIndex lies the node following the one deleted
					step = 2
					break
				case 2:
					nodes[currentIndex].anchors.left = nodes[currentIndex-1].right
					step = 0
					stop()
					break
				}
			}
		}
	}

	Rectangle {
		id: insertButtons
		width: childrenRect.width
		height: 25
		color: "transparent"
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
				currentIndex = 0
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
				currentIndex = nodes.length
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
					if(posInput.acceptableInput) {
						if(posInput.text <= 0) {
							stateText.text = "Invalid Input!"
							playStateText.start()
						}
						else {
							currentIndex = posInput.text - 1
							if(currentIndex > nodes.length) {
								stateText.text = "Can't reach a position of %1".arg(currentIndex+1)
								playStateText.start()
							}
							else {
								insertTimer.start()
							}
						}
					}
				}
			}
		}
	}

	Rectangle {
		id: removeButtons
		width: childrenRect.width
		height: 25
		color: "transparent"
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
				currentIndex = 0
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
				currentIndex = nodes.length ? nodes.length - 1 : 0
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
					if(remPosInput.acceptableInput) {
						if(remPosInput.text <= 0) {
							stateText.text = "Invalid Input!"
							playStateText.start()
						}
						else {
							currentIndex = remPosInput.text - 1
							if(currentIndex > nodes.length - 1) {
								stateText.text = "Can't reach a position of %1".arg(currentIndex+1)
								playStateText.start()
							}
							else {
								removeTimer.start()
							}
						}
					}
				}
			}
		}
	}
}