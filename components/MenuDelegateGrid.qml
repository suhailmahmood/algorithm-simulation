import QtQuick 2.2

Item {
	id: root
	width: 250
	height: 250

	property alias text: textitem.text
	signal clicked

	Rectangle {
		anchors.fill: parent
		color: "#11ffffff"
		visible: mouse.pressed
	}

	Rectangle {

	}

	Text {
		id: textitem
		color: "white"
		font.pixelSize: 32
		text: modelData
		anchors.verticalCenter: parent.verticalCenter
		anchors.left: parent.left
		anchors.leftMargin: 30
	}

	MouseArea {
		id: mouse
		anchors.fill: parent
		onClicked: root.clicked()
	}
}
