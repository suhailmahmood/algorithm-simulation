import QtQuick 2.4

Rectangle {
	id: edge
	color: "transparent"
//	opacity: 0

	property int angle: arrow.rotation
	property int length: arrow.width

//	NumberAnimation {
//		id: appearAnimation
//		target: edge
//		property: "opacity"
//		from: 0
//		to: 1
//		duration: 600
//		running: true
//		easing.type: Easing.Linear
//	}

	Image {
		id: arrow
		width: length
		height: implicitHeight
		anchors.centerIn: parent
		source: "../images/arrow.png"
		smooth: true
		clip: true
		rotation: angle
	}
}
