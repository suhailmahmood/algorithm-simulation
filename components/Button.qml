import QtQuick 2.0

Rectangle {
	id: root

	width: 100
	height: 30
	color: "steelblue"
	border {
		color: "lightgray"
		width: 1
	}

	focus: true

	property string label: buttonText.text
	signal clicked()

	Text {
		id: buttonText
		anchors.centerIn: parent
		color: "white"
		text: label
		font.pixelSize: 20
	}

	MouseArea {
		id: mouseArea
		hoverEnabled: true
		anchors.fill: parent
		onEntered: color = Qt.lighter("blue")
		onExited: color = "gray"
		onPressed: color = "blue"
		onReleased: color = Qt.lighter("blue")
		onClicked: root.clicked()
	}
}
