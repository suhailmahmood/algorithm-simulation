import QtQuick 2.0
import "../components"

Rectangle {
	id: tileWrapper
	width: 50
	height: 150
	color: "transparent"

	property alias tileColor: tile.color
	property int tileSize: tile.height
	property string tileLabel: ""

	Rectangle {
		id: tile
		width: parent.width; height: tileSize
		color: "green"
		border.color: Qt.lighter(color)
		anchors.bottom: parent.bottom

		Text {
			id: label
			color: "yellow";
			anchors.horizontalCenter: parent.horizontalCenter
			anchors.top: parent.bottom
			font {
				family: FontLoaders.papyrusFont.name
				pointSize: 18
				bold: true
			}
			text: tileWrapper.tileSize
		}
	}
}
