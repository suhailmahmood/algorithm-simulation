import QtQuick 2.4

Rectangle {
	id: root

	width: 60
	height: 60
	radius: 40
	border.color: "#1bdbec"
	border.width: 5

	// status of 0 default state, 1 is select, 2 is visited
	property int status:0
	property int label: value.text = Math.floor(Math.random() * 100 + 1)

	ColorAnimation on color {
		id: colorAnimation
		running: false
		to: Qt.lighter("orange")
		duration: 400
	}

	ColorAnimation on color {
		id: restoreColorAnimation
		running: false
		to: "white"
		duration: 400
	}

	ColorAnimation on border.color {
		id: visitAnimation
		running: false
		to: "green"
		duration: 400
	}

	ColorAnimation on border.color {
		id: selectAnimation
		running: false
		to: "yellow"
		duration: 400
	}

	ColorAnimation on border.color {
		id: unselectAnimation
		running: false
		to: "#1bdbec"
		duration: 400
	}

	onStatusChanged: {
		if(status === 1)
			selectAnimation.start()
		else if(status === 2) {
			colorAnimation.start()
			visitAnimation.start()
		}
		else {
			restoreColorAnimation.start()
			unselectAnimation.start()
		}
	}


	Text {
		id: value
		text: label
		anchors.centerIn: parent
		font.bold: true
		font.pointSize: 18
	}

	MouseArea {
		anchors.fill: parent
		onClicked: {
			status = (status + 1) % 3
			print(status)
		}
	}
}