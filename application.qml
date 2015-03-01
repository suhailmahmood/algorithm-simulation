import QtQuick 2.3
import QtQuick.Window 2.2
import "sorting"
import "components"

Window {
	id: mainWindow

	width: 1000; height: 600
	color: "#3C3C3C"
	title: "Algorithm Simulator"

	MouseArea {
		id: toggleVisibility
		anchors.fill: parent
		onDoubleClicked: {
			// visibility is 2 for Windowed, and 5 for FullScreen
			mainWindow.visibility = mainWindow.visibility === 5 ? "Windowed" : "FullScreen"
		}
	}

	Loader {
		id: loader
		anchors.fill: parent
		anchors.horizontalCenter: parent.horizontalCenter
		asynchronous: true			// causes loading and compilation to run on background thread, results in smoother animation, if any
		visible: status == Loader.Ready
	}

	PlasticButton {
		id: exitButton
		width: 100
		height: 40
		radius: 20
		text: "Exit"
		x: parent.width - 120
		y: 20
		onClicked: Qt.quit()
	}

	PlasticButton {
		id: backButton
		width: 100
		height: 40
		radius: 20
		text: "Back"
		x: 20
		y: parent.height - 60
		visible: false
		onClicked: {
			loader.setSource("")
			visible = false
			choiceRing.visible = true
		}
	}

	Rectangle {
		id: choiceRing
		anchors.centerIn: parent
		width: 400; height: 250
        radius: 30
		color: "transparent"

		SideRect {
			id: leftRect
			anchors { verticalCenter: parent.verticalCenter; horizontalCenter: parent.left }
			text: "BubbleSort"
			onClicked: {
				loader.setSource("sorting/BubbleSort.qml")
				backButton.visible = true
				choiceRing.visible = false
			}
		}

		SideRect {
			id: rightRect
			anchors { verticalCenter: parent.verticalCenter; horizontalCenter: parent.right }
			text: "SelectionSort"
			onClicked: {
				loader.setSource("sorting/SelectionSort.qml", { tileCount: 10 })
				backButton.visible = true
				choiceRing.visible = false
			}
		}

		SideRect {
			id: topRect
			anchors { verticalCenter: parent.top; horizontalCenter: parent.horizontalCenter }
			text: "InsertionSort"
			onClicked: {
				loader.setSource("sorting/InsertionSort.qml", {tileCount: 10})
				backButton.visible = true
				choiceRing.visible = false
			}
		}

		SideRect {
			id: bottomRect
			anchors { verticalCenter: parent.bottom; horizontalCenter: parent.horizontalCenter }
			text: "MergeSort"
		}

		SideRect {
			id: centerRect
			anchors { verticalCenter: parent.verticalCenter; horizontalCenter: parent.horizontalCenter }
			text: "QuickSort"
		}

		Rectangle {
			id: focusRect

			property string text

			x: parent.width/2 - width/2; y: parent.height/2 - height/2
			visible: false
			width: 120; height: 50
			radius: 6
			border.width: 4; border.color: "white"
			color: "firebrick"

			Behavior on x {
				NumberAnimation { easing.type: Easing.OutElastic; easing.amplitude: 3.0; easing.period: 2.0; duration: 300 }
			}
			Behavior on y {
				NumberAnimation { easing.type: Easing.OutElastic; easing.amplitude: 3.0; easing.period: 2.0; duration: 300 }
			}

			Text {
				id: focusText
				text: focusRect.text
				anchors.centerIn: parent
				color: "white"
				font.pixelSize: 16; font.bold: true

				// Set a behavior on the focusText's x property:
				// Set the opacity to 0, set the new text value, then set the opacity back to 1.
				Behavior on text {
					SequentialAnimation {
						NumberAnimation { target: focusText; property: "opacity"; to: 0; duration: 150 }
						NumberAnimation { target: focusText; property: "opacity"; to: 1; duration: 150 }
					}
				}
			}
			onTextChanged: visible = true
		}
	}
}
