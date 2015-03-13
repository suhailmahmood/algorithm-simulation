import QtQuick 2.4

Rectangle {
	id: edge
	color: "transparent"
	opacity: 0

	property color arrowColor: "red"
	property int edgeLength: bar.width=50

	NumberAnimation {
		id: appearAnimation
		target: edge
		property: "opacity"
		from: 0
		to: 1
		duration: 600
		running: true
		easing.type: Easing.OutBounce
	}

	Rectangle {
		id: arrowHead
		width: 10
		height: 10
		rotation: 45
		radius: 2
		color: arrowColor
		anchors.centerIn: parent
	}

	Rectangle {
		id: bar
		width: 115
		height: 8
		radius: 8
		color: arrowColor
		anchors.left: arrowHead.horizontalCenter
		anchors.verticalCenter: arrowHead.verticalCenter
	}
}
