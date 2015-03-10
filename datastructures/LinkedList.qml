import QtQuick 2.3
import "../components"
import "../scripts/script.js" as Functions

Rectangle {
	id: root
	width: 640; height: 480

	property var items: []
	property int count

	function insertAtPos(pos) {
		var node = Qt.createComponent("../components/Node.qml")
		items[count++] = node.createObject(root, { "x": Math.random()*500, "y": Math.random()*500, "value": Math.floor(Math.random()*100) } )
	}

	function removeFromPos(pos) {

	}

	Button {
		id: insertButton
		width: 120
		height: 40
		text: "Insert"
		textSize: 18
		fontFamily: FontLoaders.papyrusFont.name
		boldText: true
		onClicked: insertAtPos(0)
	}
}
