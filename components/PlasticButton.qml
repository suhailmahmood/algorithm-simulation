import QtQuick 2.0

Rectangle  {
	id: root

	property string text: "Button"
	property color buttonColor: "gray"
	property variant webfont: FontLoader {
		source: "../fonts/Papyrus.ttf"
	}

	signal clicked()
	signal doubleClicked()

	width: 100
	height: 30
	border  { width: 1; color: Qt.darker(buttonColor) }
	smooth: true
	radius: 3

	// color the button with a gradient
	gradient: Gradient  {
		GradientStop  {
			id: gradient
			position: 0.0
			color:  {
				if (mouseArea.pressed)
					return Qt.darker(buttonColor)
				else
					return Qt.lighter(buttonColor)
			}
		}
		GradientStop  { position: 1.0; color: buttonColor }
	}

	MouseArea  {
		id: mouseArea
		anchors.fill: parent
		hoverEnabled: true
		onClicked: parent.clicked()
		onDoubleClicked: parent.doubleClicked()
	}

	Text  {
		id: buttonLabel
		anchors.centerIn: parent
		color: "white"
		font {
			family: webfont.name
			bold: true
			pixelSize: 17
		}

		text: parent.text
	}
}
