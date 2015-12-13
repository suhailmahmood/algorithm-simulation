import QtQuick 2.3
import "../../components"

Rectangle {
	id: root
	width: parent.width; height: parent.height
	color: "#3C3C3C"

	Loader {
		id: loader
		anchors.fill: parent
		anchors.horizontalCenter: parent.horizontalCenter
		asynchronous: true
		visible: status === Loader.Ready
	}

	Button {
		id: backButton
		width: 100
		height: 40
		text: "Back"
		textSize: 14
		boldText: true
		fontFamily: FontLoaders.papyrusFont.name
		x: 20
		y: 20
		opacity: 0
		onClicked: {
			loader.setSource("")
			opacity = 0
			choiceRing.visible = true
		}
	}

	Rectangle {
		id: choiceRing
		anchors.centerIn: parent
		width: 280; height: 250
        radius: 30
		color: "transparent"

		SideRect {
			id: leftRect
			anchors { verticalCenter: parent.verticalCenter; horizontalCenter: parent.left }
			text: "BFS"
			onClicked: {
				loader.setSource("BFS.qml")
				backButton.opacity = 1
				choiceRing.visible = false
			}
		}

		SideRect {
			id: rightRect
			anchors { verticalCenter: parent.verticalCenter; horizontalCenter: parent.right }
			text: "DFS"
			onClicked: {
				loader.setSource("DFS.qml")
				backButton.opacity = 1
				choiceRing.visible = false
			}
		}

//		SideRect {
//			id: centerRect
//			anchors { verticalCenter: parent.verticalCenter; horizontalCenter: parent.horizontalCenter }
//			text: "Queue"
//			onClicked: {
//				loader.setSource("Queue.qml")
//				backButton.opacity = 1
//				choiceRing.visible = false
//			}
//		}

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
