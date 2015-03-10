import QtQuick 2.4
import "../scripts/script.js" as Functions

Rectangle {
	id: root
	width: 800
	color: "transparent"

	property var dataInput: []
	property int drawerHeight: 30

	Button {
		id: drawerButton
//		anchors.centerIn: parent	// delete after testing
		width: 40
		height: drawerHeight
		z:3
		text: ">"
		textSize: 15
		onClicked: {
			button1.x = button1.x < 0 ? drawerButton.width : -180
			userInputPanel.x = -(userInputPanel.width + goButton.width)
			text = text === "<" ? ">" : "<"
		}
	}

	Button {
		id: button1
		width: 90
		height: drawerHeight
		x: -(button1.width + button2.width)
		z: 2
		anchors.verticalCenter: drawerButton.verticalCenter
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
		id: button2
		width: 90
		height: drawerHeight
		z: 2
		anchors.left: button1.right
		anchors.verticalCenter: drawerButton.verticalCenter
		text: "User Input"
		textSize: 10
		onClicked: userInputPanel.x = userInputPanel.x < 0 ? button2.x + button2.width : -(userInputPanel.width + goButton.width)
	}

	Rectangle {
		id: userInputPanel
		width: 300
		height: drawerHeight
		anchors.verticalCenter: drawerButton.verticalCenter
		border {
			color: "lightgray"
			width: 1
		}
		color: "#e61c1c"
		x: -(width + goButton.width)
		z: 1

		TextInput {
			id: textInput
			anchors.verticalCenter: parent.verticalCenter
			cursorVisible: true
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

		Button {
			id: goButton
			width: 40
			height: drawerHeight
			z: 1
			anchors {
				verticalCenter: userInputPanel.verticalCenter
				left: userInputPanel.right
			}

			text: "Go"
			textSize: 10
			onClicked: {
				root.dataInput = textInput.text.split(',')
			}
		}
	}
}
