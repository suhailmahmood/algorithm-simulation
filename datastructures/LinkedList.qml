import QtQuick 2.3
import "../components"
import "../scripts/script.js" as Functions

Rectangle {
	id: root
	width: 720; height: 480

	property var items: []
	property int count

	function insertNode(pos) {
		var node = Qt.createComponent("../components/Node.qml")
		items[count++] = node.createObject(root, { "x": items[pos].x - 100, "y": items[pos].y + 50, "value": Math.floor(Math.random()*100) } )
	}

	function removeNode(pos) {
		items[0].x = Math.floor(Math.random() * 400)
		items[0].y = Math.floor(Math.random() * 400)
	}

	Component.onCompleted: {
		var head = Qt.createComponent("../components/Node.qml")
		items[count++] = head.createObject(root, { "x": 100, "y": root.height/2, "value": 10 })
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
			onClicked: insertNode(0)
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
			onClicked: insertNode(count)
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
				text: "pos"
				selectByMouse: true
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
					if(posInput.acceptableInput)
						insertNode(posInput.text)
				}
			}
		}
	}
}