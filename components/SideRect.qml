import QtQuick 2.0

Rectangle {
	id: myRect

	property string text
	signal clicked()

	width: 120; height: 50
	radius: 6
	color: "#646464"
	border.width: 2; border.color: "white"

	MouseArea {
		anchors.fill: parent
		hoverEnabled: true
		onEntered: {
			focusRect.x = myRect.x;
			focusRect.y = myRect.y;
			focusRect.text = myRect.text;
		}
		onClicked: myRect.clicked()
	}
}