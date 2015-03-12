import QtQuick 2.3
import "../../components"
import "../../scripts/script.js" as Functions

Rectangle {
	id: root
	width: 640; height: 520

	property int limit: 10
	property var items: []
	property int count
	property int serial: 1
	property string compStr: "import QtQuick 2.3; Rectangle { id: comp; x: -100; y: -31; width: 100; height: 30; color: 'yellow';
		Text { text:'"+serial+"'; anchors.centerIn: parent }
		SequentialAnimation { running: true
		NumberAnimation {target: comp; property: 'x'; duration: 300; to: 1; easing.type: Easing.OutQuart}
		NumberAnimation {target: comp; property: 'y'; duration: 800; to: stack.height - (count+1)*(height+1); easing.type: Easing.OutExpo}}
		Behavior on y { NumberAnimation {duration: 500; easing.type: Easing.InCirc} }
		Behavior on opacity { NumberAnimation {duration: 500}}
		}"

	Rectangle {
		id: stack
		anchors.centerIn: parent
		width: 102; height: 311
		color: Qt.lighter("red")
		border {
			width: 1
			color: "#b1a33b"
		}

		function push() {
			if(count === limit) {
				stateText.text = "Stack Overflow!"
				stateText.y = stack.y - 100
				playStateText.start()
			}
			else {
				items[count] = Qt.createQmlObject(compStr, stack, "")
				count++
				serial++
				tosAnimation.start()
			}
		}

		function pop() {
			if(count === 0) {
				stateText.text = "Stack Underflow!"
				stateText.y = stack.y + stack.height + 30
				playStateText.start()
			}
			else {
				items[count-1].y -= 700
				items[count-1].opacity = 0
				tosAnimation.start()
				count--
			}
		}

		Text {
			id: tos
			text: "   TOS"
			font {
				family: FontLoaders.papyrusFont.name
				pointSize: 13
				bold: true
			}
			opacity: 0
			smooth: true
			anchors.left: stack.right
			anchors.verticalCenter: count === 0 ? parent.bottom : items[count-1].verticalCenter
			SequentialAnimation {
				id: tosAnimation
				NumberAnimation { target: tos; property: "opacity"; to: 0; duration: 0}
				NumberAnimation { target: tos; property: "opacity"; to: 0; duration: 1000 }
				NumberAnimation { target: tos; property: "opacity"; to: 1; duration: 600 }
			}
		}
	}

	Text {
		id: stateText
		text: ""
		font.pointSize: 20
		anchors.horizontalCenter: stack.horizontalCenter
		y: stack.y - 100
		opacity: 0.0

		SequentialAnimation {
			id: playStateText
			running: false
			NumberAnimation { target: stateText; property: "opacity"; to: 1; duration: 300 }
			NumberAnimation { target: stateText; property: "opacity"; to: 1; duration: 2000 }
			NumberAnimation { target: stateText; property: "opacity"; to: 0; duration: 1000 }
		}
	}

	Keys.onDownPressed: stack.push()
	Keys.onUpPressed: stack.pop()
	Keys.onSpacePressed: stack.push()
	Keys.onDeletePressed: stack.pop()

	Button {
		id: pushButton
		text: "PUSH"
		textSize: 10
		width: 100; height: 30
		anchors.right: popButton.left
		anchors.bottom: parent.bottom
		onClicked: stack.push()
	}

	Button {
		id: popButton
		text: "POP"
		textSize: 10
		width: 100; height: 30
		x: parent.width / 2
		anchors.bottom: parent.bottom
		onClicked: stack.pop()
	}
}
