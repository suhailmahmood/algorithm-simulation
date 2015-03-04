import QtQuick 2.4
import "../scripts/script.js" as Functions

Rectangle {
	id: root

	property var dataInput: []

	Button {
		id: drawerButton
		width: 40
		height: 30
		z:2
		text: ">"
		textSize: 15
		onClicked: {
			randomInput.x = randomInput.x < 0 ? drawerButton.width : -180
			userInputPanel.x = -300
			text = text === "<" ? ">" : "<"
		}
	}

	Button {
		id: randomInput
		width: 90
		height: 30
		x: -180
		z: 1
		text: "Random"
		textSize: 10
		Behavior on x {
			NumberAnimation { duration: 400; easing.type: Easing.InOutQuad }
		}
		onClicked: {
			root.dataInput = Functions.getNRandom()
		}
	}

	Button {
		id: userInput
		width: 90
		height: 30
		z: 1
		anchors.left: randomInput.right
		text: "User Input"
		textSize: 10
		onClicked: userInputPanel.x = userInputPanel.x < 0 ? 220 : -300
	}

	Rectangle {
		id: userInputPanel
		width: 300
		height: drawerButton.height
		border {
			color: "lightgray"
			width: 1
		}
		color: "#e61c1c"
		x: -width

		TextInput {
			id: textInput
			anchors.verticalCenter: parent.verticalCenter
			cursorVisible: false
			color: "white"
			text: "input..."
			selectByMouse: true
			font {
				pixelSize: 17
			}
			validator: RegExpValidator { regExp: /[0-9]{1,2}(,[0-9]{1,2})*/ }
		}
		Behavior on x {
			NumberAnimation { duration: 400; easing.type: Easing.InOutQuad }
		}
	}

	Button {
		id: goButton
		width: 40
		height: drawerButton.height
		anchors.left: userInputPanel.right
		text: "Go"
		textSize: 10
		onClicked: {
			root.dataInput = textInput.text.split(',')
		}
	}
}
