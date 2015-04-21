import QtQuick 2.4
import "../../components"
import "../../scripts/script.js" as Functions

Rectangle {
	id: root

	width: parent.width; height: 80
	color: Qt.rgba(0, 0, 0, 0.8)
	y: parent.height - height

	property alias sliderValue: slider.value
	property alias sliderMaxVal: slider.maximumValue
	property alias sliderMinVal: slider.minimumValue
	property alias sliderColor: slider.sliderColor

	Rectangle {
		id: paneTopBorder
		height: 1
		width: parent.width
		color: "#cfc0c0"
		anchors.bottom: parent.top
	}

	Button {
		id: start_pause
		width: 130
		height: 50
		text: {
			if(!timer.running)
				return "Start"
			else
				return "Pause"
		}
		fontFamily: FontLoaders.papyrusFont.name
		boldText: true
		textSize: 15
		anchors.left: root.horizontalCenter
		anchors.verticalCenter: root.verticalCenter
		onClicked: {
			if(!sorted && tilesRow.dataArray.length === 0) {
				tilesRow.dataArray = Functions.getNRandom()
				timer.start()
			}
			else if(sorted) {
				timer.reset()
				timer.start()
			}
			else {
				timer.running ? timer.stop() : timer.start()
			}

			timer.repeat = true
		}
	}

	Button {
		id: oneStep
		width: 40
		height: 50
		text: "    1\nStep"
		fontFamily: FontLoaders.papyrusFont.name
		boldText: true
		textSize: 10
		anchors.left: start_pause.right
		y: start_pause.y
		onClicked: {
			timer.repeat = false
			timer.start()
		}
	}

	Slider {
		id: slider

		x: root.width - width - 10
		width: 200; height: 30
		stepSize: 50
		anchors.verticalCenter: parent.verticalCenter
	}

	Drawer {
		id: drawer
		anchors.top: root.top
		anchors.left: parent.left
		onDataInputChanged: {
			tilesRow.dataArray = drawer.dataInput
			timer.reset()
		}
	}
}