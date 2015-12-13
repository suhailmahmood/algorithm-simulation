import QtQuick 2.4
import "../components"

Rectangle {
	id: root

	Text {
		id: label
		text: "Suhail Mahmood"
		font.family: FontLoaders.papyrusFont.name
		font.pointSize: 20
		anchors.centerIn: parent
	}

	Behavior on color {
		ColorAnimation {
			duration: 2000
		}
	}

	Timer {
		id: timer
		repeat: true
		interval: 2000
		running: true
		triggeredOnStart: true
		onTriggered: parent.color = Qt.rgba(Math.random(), Math.random(), 0.8)
	}
}