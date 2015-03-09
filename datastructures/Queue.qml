import QtQuick 2.3
import "../components"
import "../scripts/script.js" as Functions

Rectangle {
	id: root
	width: 640; height: 520
	property int limit: 10
	property var items: []
	property int count:1
	property int serial: 1
	property string compStr: "import QtQuick 2.3; Rectangle { id: comp; x: -50; y: 110; width: 30; height: 100; color: 'yellow';
			Text { text:'"+serial+"'; anchors.centerIn: parent }
			SequentialAnimation { running: true
			NumberAnimation {target: comp; property: 'y'; duration: 300; to: 1; easing.type: Easing.OutExpo}
			NumberAnimation {target: comp; property: 'x'; duration: 800; to: queue.width - count*(width+1); easing.type: Easing.OutExpo}}
			Behavior on x { NumberAnimation {duration: 500; easing.type: Easing.InCirc} }
			Behavior on opacity { NumberAnimation {duration: 500}}
			}"

	Rectangle {
		id: queue
		anchors.centerIn: parent
		width: 450; height: 102
		color: Qt.lighter("red")
		border {
			width: 1
			color: "#b1a33b"
		}

		function push() {
			if(count > limit) {
				stateText.text = "Queue Overflow!"
				playStateText.start()
			}
			else {
				items[count] = Qt.createQmlObject(compStr, queue, "")
				count++
				serial++
			}
		}

		function pop() {
			if(count === 1) {
				stateText.text = "Queue Underflow!"
				playStateText.start()
			}
			else {
				items[1].x += 700
				items[1].opacity = 0
				for(var i=1; i<count-1; i++) {
					items[i] = items[i+1]
					items[i].x += 31
				}
				count--
			}
		}
	}

	Text {
		id: stateText
		text: ""
		font.pointSize: 20
		anchors.horizontalCenter: queue.horizontalCenter
		y: queue.y - 100
		opacity: 0.0

		SequentialAnimation {
			id: playStateText
			running: false
			NumberAnimation { target: stateText; property: "opacity"; to: 1; duration: 300 }
			NumberAnimation { target: stateText; property: "opacity"; to: 1; duration: 2000 }
			NumberAnimation { target: stateText; property: "opacity"; to: 0; duration: 1000 }
		}
	}

	Button {
		id: pushButton
		text: "PUSH"
		textSize: 10
		width: 100; height: 30
		anchors.right: popButton.left
		anchors.bottom: parent.bottom
		onClicked: queue.push()
	}

	Button {
		id: popButton
		text: "POP"
		textSize: 10
		width: 100; height: 30
		x: parent.width / 2
		anchors.bottom: parent.bottom
		onClicked: {
			enabled = false
			queue.pop()
			disablePop.start()
		}
	}

	Timer {
		id: disablePop
		interval: 500
		onTriggered: popButton.enabled = true
	}
}
