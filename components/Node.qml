import QtQuick 2.3
import "../components"

Rectangle {
	id: node
	width: childrenRect.width
	height: 30
	color: "transparent"
	opacity: 0
	property int value: label.text=10

	SequentialAnimation {
		id: appearanceAnimation
		running: true
		NumberAnimation { target: node; property: "opacity"; from: 0; to: 1; duration: 600; easing.type: Easing.Linear }
	}

	Behavior on x {
		NumberAnimation { duration: 400; easing.type: Easing.OutSine }
	}

	Behavior on y {
		NumberAnimation { duration: 400; easing.type: Easing.OutSine}
	}

	Rectangle {
		id: dataField
		width: 70
		height: parent.height
		color: "lightgreen"
		radius: 3

		Text {
			id: label
			font {
				family: FontLoaders.papyrusFont.name
				pointSize: 12
				bold: true
			}
			text: value
			anchors.centerIn: parent
		}
	}

	Rectangle {
		id: pointer
		width: 25
		height: parent.height
		anchors.left: dataField.right
		color: "lightpink"
		radius: 3
		Rectangle {
			width: parent.width / 4
			height: width
			radius: width
			anchors.centerIn: parent
			color: "red"
		}
	}
}