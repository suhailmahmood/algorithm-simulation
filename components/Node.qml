import QtQuick 2.3
import "../components"

Rectangle {
	id: node
	objectName: "noe"
	width: childrenRect.width; height: 30
	color: "transparent"
	opacity: 0
	anchors.verticalCenter: parent.verticalCenter

	property int value: label.text=10
	property NumberAnimation appear: appearanceAnimation

	NumberAnimation {
		id: appearanceAnimation
		target: node; property: "opacity"; from: 0; to: 1; duration: 400; easing.type: Easing.Linear
	}

	Behavior on x {
		NumberAnimation { duration: 400; easing.type: Easing.OutSine; alwaysRunToEnd: true }
	}

	Behavior on y {
		NumberAnimation { duration: 700; easing.type: Easing.InQuart}
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
	Rectangle {
		id: gap
		width: 15
		color: "transparent"
		anchors.left: pointer.right
	}
}