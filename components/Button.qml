import QtQuick 2.0

Rectangle {
	id: root

	color: normalColor
	focus: true
	border {
		color: "lightgray"
		width: 1
	}

	property color normalColor: "black"
	property color hoverColor: "#777171"
	property color pressedColor: Qt.darker(hoverColor)
	property string text: buttonText.text= "Button"
	property int textSize: buttonText.font.pointSize
	property font fontFamily: buttonText.font.family
	property bool boldText: buttonText.font.bold

	signal clicked()

	Text {
		id: buttonText
		anchors.centerIn: parent
		color: "white"
		text: root.text
		font.pointSize: root.textSize
		font.family: root.fontFamily
		font.bold: root.boldText
	}

	MouseArea {
		id: mouseArea
		hoverEnabled: true
		anchors.fill: parent
		onPressed: color = pressedColor
		onReleased: color = mouseArea.containsMouse ? hoverColor : color
		onClicked: root.clicked()

	}

	states:
		State {
			name: "mouseIn"; when: mouseArea.containsMouse;
			PropertyChanges {
				target: root; color: hoverColor
			}
		}

	Behavior on color {
		ColorAnimation { duration: 300 }
	}
}
