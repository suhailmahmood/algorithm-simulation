import QtQuick 2.3
import "../components"

Rectangle {
	id: node
	width: dataField.width + pointer.width
	height: 40

	property int value: label.text=10

	Rectangle {
		id: dataField
		width: 90
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
		width: 40
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