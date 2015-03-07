import QtQuick 2.3
import "../components"
import "../scripts/script.js" as Functions

Rectangle {
	id: root
	width: 640; height: 520

	property int limit: 10
	property var items: []
	property int count:1
	property string compStr: "import QtQuick 2.3; Rectangle { id: comp; x: -100; y: 100; width: 100; height: 30; color: 'yellow';
		Text { text:'"+count+"'; anchors.centerIn: parent }
		SequentialAnimation { running: true
		NumberAnimation {target: comp; property: 'x'; duration: 300; to: 1; easing.type: Easing.OutQuart}
		NumberAnimation {target: comp; property: 'y'; duration: 800; to: stack.height - count*(height+1); easing.type: Easing.OutExpo}}
		Behavior on y { NumberAnimation {duration: 500; easing.type: Easing.InCirc} }
		Behavior on opacity { NumberAnimation {duration: 500}}
		}"

	Rectangle {
		id: stack
		anchors.centerIn: parent
		width: 102; height: 450
		color: Qt.lighter("red")
		border {
			width: 1
			color: "#b1a33b"
		}

		function push() {
			if(count > limit)
				print("StackOverflow!")
			else {
				items[count] = Qt.createQmlObject(compStr, stack, "")
				count++
			}
		}

		function pop() {
			if(count === 1) {
				print("Underflow")
			}
			else {
				items[count-1].y -= 700
				items[count-1].opacity = 0
				count--
			}
		}

		Text {
			id: tos
			text: "TOS"
			anchors.left: items[count-1].right
			anchors.verticalCenter: items[count-1].verticalCenter
			Behavior on y {
				NumberAnimation {duration: 400; easing.type: Easing.OutBounce}
			}
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
