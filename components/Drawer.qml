import QtQuick 2.4
import QtQuick.Controls 1.3
import QtQuick.Controls.Styles 1.3
import "../scripts/script.js" as Functions
import "../components"		// needed to override Button type in 'QtQuick.Controls 1.3'

Rectangle {
	id: root
	width: 800
	color: "transparent"

	property var dataInput: []
	property int drawerHeight: 30

	Button {
		id: drawerButton

		width: 40; height: drawerHeight
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

		width: 90; height: drawerHeight
		x: -(button1.width + button2.width)
		z: 2
		anchors.verticalCenter: drawerButton.verticalCenter

		text: "Random"
		textSize: 10

		Behavior on x { NumberAnimation { duration: 400; easing.type: Easing.InOutQuad } }
		onClicked: root.dataInput = Functions.getNRandom()
	}

	Button {
		id: button2

		width: 90; height: drawerHeight
		z: 2
		anchors.left: button1.right
		anchors.verticalCenter: drawerButton.verticalCenter
		text: "User Input"
		textSize: 10

		onClicked: userInputPanel.x = userInputPanel.x < 0 ? button2.x + button2.width : -(userInputPanel.width + goButton.width)
	}

	Rectangle {
		id: userInputPanel

		x: -(width + goButton.width)
		z: 1
		width: 300; height: drawerHeight
		anchors.verticalCenter: drawerButton.verticalCenter

		Behavior on x { NumberAnimation { duration: 400; easing.type: Easing.InOutQuad } }

		TextField {
			id: textField

			width: parent.width; height: parent.height
			anchors.verticalCenter: parent.verticalCenter

			validator: RegExpValidator { regExp: /[0-9]{1,2}(,[0-9]{1,2})*/ }

			style: TextFieldStyle {
				textColor: "white"
				font {
					pixelSize: 16
				}
				background: Rectangle {
					radius: 1
					color: "#e61c1c"
					implicitWidth: 100
					implicitHeight: 40
					border.color: "lightgray"
					border.width: 1
				}
			}
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
				root.dataInput = textField.text.split(',')
			}
		}
	}
}
