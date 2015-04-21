import QtQuick 2.0

Rectangle {
	id: root

	color: normalColor
	border {
		color: "lightgray"
		width: 1
	}

	property color normalColor: "black"
	property color hoverColor: "#777171"
	property color pressedColor: Qt.darker(hoverColor)

	property alias text: buttonText.text
	property alias textSize: buttonText.font.pointSize
	property alias fontFamily: buttonText.font.family
	property alias boldText: buttonText.font.bold

	signal clicked()

	Text {
		id: buttonText
		anchors.centerIn: parent
		color: "white"
	}

	MouseArea {
		id: buttonArea
		hoverEnabled: true
		anchors.fill: parent
		onPressed: color = pressedColor
		onReleased: color = buttonArea.containsMouse ? hoverColor : color
		onClicked: root.clicked()

	}

	states:
		State {
			name: "mouseIn"; when: buttonArea.containsMouse;
			PropertyChanges {
				target: root; color: hoverColor
			}
		}

	Behavior on color {
		ColorAnimation { duration: 300 }
	}

	scale: buttonArea.pressed ? 0.95 : 1.00
	Behavior on scale { NumberAnimation{ duration: 55 } }
}
