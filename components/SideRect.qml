import QtQuick 2.0

Rectangle {
	id: myRect

	property string text: label.text
	signal clicked()

	width: 120; height: 50
	radius: 6
	color: "#646464"
	border.width: 2; border.color: "white"

	Text {
		id: label
		anchors.centerIn: parent
		color: "white"
		font.pixelSize: 16
		text: myRect.text
		opacity: 0.5
	}

	MouseArea {
		anchors.fill: parent
		hoverEnabled: true
		onEntered: {
			focusRect.x = myRect.x;
			focusRect.y = myRect.y;
			focusRect.text = myRect.text;
			label.visible = false
		}
		onExited: {
			label.visible = true
		}

		onClicked: myRect.clicked()
	}
}
