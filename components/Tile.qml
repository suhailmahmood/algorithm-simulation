import QtQuick 2.0

Rectangle {
	id: tile

	property string tileLabel: label.text
	property int tileSize: height
	property variant webfont: FontLoader {
		source: "../fonts/Papyrus.ttf"
	}

	width: 50
	height: { if(tileSize === 0) return 1; else tileSize; }
	color: "green"
	border.color: Qt.lighter(color)

	Text {
		id: label
		color: "yellow";
		anchors.horizontalCenter: parent.horizontalCenter
		font {
			family: webfont.name
			pixelSize: 25
			bold: true
		}
		anchors.top: parent.bottom
		text: tileLabel
	}
}
