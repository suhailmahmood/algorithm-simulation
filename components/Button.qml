import QtQuick 2.0

Rectangle {
	id: root

	color: "black"
	focus: true
	border {
		color: "lightgray"
		width: 1
	}
	property color hoverColor: "#777171"
	property color pressedColor: Qt.darker(hoverColor)
	property string text: buttonText.text= "Button"
	property int textSize: buttonText.font.pointSize=8

	signal clicked()

	Text {
		id: buttonText
		anchors.centerIn: parent
		color: "white"
		text: root.text
		font.pointSize: root.textSize
	}

	MouseArea {
		id: mouseArea
		hoverEnabled: true
		anchors.fill: parent
		onEntered: color = hoverColor
		onExited: color = "black"
		onPressed: color = pressedColor
		onReleased: color = mouseArea.containsMouse ? hoverColor : color
		onClicked: root.clicked()
	}
}
