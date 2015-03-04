import QtQuick 2.0

Rectangle {
	id: codeWrapper

	width: 340; height: 100
	color: "#e0d4d4"
	radius: 8

	property var pseudocode: ["this is sample", "pseudo-codes", "go here"]

	function highlightLine(line) {
		for(var i=0; i<repeater.count; i++) {
			if(line === i) {
				repeater.itemAt(i).color = "red"
			}
			else {
				repeater.itemAt(i).color = "black"
			}
		}
	}

	Column {
		id: codeArea
		anchors.centerIn: parent
		Repeater {
			id: repeater
			model: pseudocode.length
			delegate: Text {
				text: pseudocode[index]
				font {
					family: "consolas"
					pixelSize: 16
				}
			}
		}
	}
}
