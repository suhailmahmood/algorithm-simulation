import QtQuick 2.3
import "../components"
import "../scripts/script.js" as Functions

Rectangle {
	id: root
	width: 600; height: 400


	ListView {
		id: stack
		width: 240; height: 320
		model: ListModel {}

		delegate: Rectangle {
			width: 100; height: 30
			color: "#1ceaf1"
			border {
				width: 1
				color: Qt.lighter(color)
			}
			Text {
				anchors.centerIn: parent
				text: name
			}
		}

		add: Transition {
			NumberAnimation { property: "opacity"; from: 0; to: 1.0; duration: 400 }
			NumberAnimation { property: "scale"; from: 0; to: 1.0; duration: 400 }
		}

		displaced: Transition {
			NumberAnimation { properties: "x,y"; duration: 400; easing.type: Easing.OutBounce }
			NumberAnimation { property: "opacity"; to: 1.0 }
			NumberAnimation { property: "scale"; to: 1.0 }
		}

		focus: true
		function pushItem() {
			if(model.count <= 10)
				model.insert(0, { "name": "Item " + model.count })
			else
				print("stackoverflow.com")
		}

		function popItem() {
			if(model.count)
				model.remove(0)
			else
				print("Underflow")
		}
	}

	Button {
		id: pushButton
		text: "Push"
		textSize: 15
		width: 100; height: 40
		anchors.right: popButton.left
		anchors.bottom: parent.bottom
		onClicked: stack.pushItem()
	}

	Button {
		id: popButton
		text: "Pop"
		textSize: 15
		width: 100; height: 40
		x: parent.width / 2
		anchors.bottom: parent.bottom
		onClicked: stack.popItem()
	}
}
