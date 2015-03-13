import QtQuick 2.4
import QtQuick.Controls 1.3
import QtQuick.Controls.Styles 1.3
import "../../components"

Rectangle {
	id: root
	color: "#8899d6ee"

	property int speed: 800
	property color nColor: "#caea97"
	property color resultColor: "#89c030"
	property var n1Bits: [0,0,0,0,0,0,0,0]
	property var n2Bits: [0,0,0,0,0,0,0,0]
	property var resultBits: toBitArray(result)
	property int n1: parseInt(n1Bits.join(""), 2)
	property int n2: parseInt(n2Bits.join(""), 2)
	property int result: parseInt(resultBits.join(""), 2)

	function toBitArray(n) {
		var value = parseInt(n)
		if(value >= 0) {
			var binaryBits = value.toString(2).split('')
			var len = binaryBits.length
			for(var i=0; i<8-len; i++)
				binaryBits.splice(0, 0, 0)
			return binaryBits
		}
		else return [0,0,0,0,0,0,0,]
	}

	function updateBitsRow(source, text) {
		var binaryBits = toBitArray(text)
		switch(source) {
		case 1:
			n1Bits = binaryBits.slice()
			break
		case 2:
			n2Bits = binaryBits.slice()
			break
		}
	}

	Timer {
		id: timer
		interval: speed
		repeat: true
		property string job
		property int i
		property var temp: []
		property int step

		function reset() {
			temp = []
			for(i=0; i<8; i++) {
				resultRepeater.itemAt(i).color = resultColor
				n1Repeater.itemAt(i).color = n2Repeater.itemAt(i).color = nColor
			}
			i = step = result = 0
			resultLabel.opacity = 0
			stop()
		}
		onTriggered: {
			switch(job) {
			case "AND":
				if(!step) {
					temp = (n1 & n2)
					step = 1
				}
				result = result | (temp & (1 << i))
				n1Repeater.itemAt(7-i).color = n2Repeater.itemAt(7-i).color = Qt.darker(nColor)
				resultRepeater.itemAt(7-i).color = Qt.darker(resultColor)
				i++
				if(i === 8) {
					resultLabel.text = "Result of " + n1 + " AND " + n2 + " is " + result
					resultLabel.opacity = 1
					step = 0
					stop()
				}
				break
			case "OR":
				if(!step) {
					temp = (n1 | n2)
					step = 1
				}
				result = result | (temp & (1 << i))
				n1Repeater.itemAt(7-i).color = n2Repeater.itemAt(7-i).color = Qt.darker(nColor)
				resultRepeater.itemAt(7-i).color = Qt.darker(resultColor)
				i++
				if(i === 8) {
					resultLabel.text = "Result of " + n1 + " OR " + n2 + " is " + result
					resultLabel.opacity = 1
					stop()
					step = 0
				}
				break
			case "XOR":
				if(!step) {
					temp = (n1 ^ n2)
					step = 1
				}
				result = result | (temp & (1 << i))
				n1Repeater.itemAt(7-i).color = n2Repeater.itemAt(7-i).color = Qt.darker(nColor)
				resultRepeater.itemAt(7-i).color = Qt.darker(resultColor)
				i++
				if(i === 8) {
					resultLabel.text = "Result of " + n1 + " XOR " + n2 + " is " + result
					resultLabel.opacity = 1
					stop()
					step = 0
				}
				break
			}
		}
	}

	Row {
		id: buttonsRow
		width: childrenRect.width
		height: 35
		anchors.horizontalCenter: parent.horizontalCenter

		Button {
			id: andButton
			width: 120; height: parent.height
			text: "AND"
			fontFamily: FontLoaders.papyrusFont.name
			boldText: true
			textSize: 15
			onClicked: {
				timer.job = "AND"
				timer.reset()
				timer.start()
			}
		}

		Button {
			id: orButton
			width: 120; height: parent.height
			text: "OR"
			fontFamily: FontLoaders.papyrusFont.name
			boldText: true
			textSize: 15
			onClicked: {
				timer.job = "OR"
				timer.reset()
				timer.start()
			}
		}

		Button {
			id: xorButton
			width: 120; height: parent.height
			text: "XOR"
			fontFamily: FontLoaders.papyrusFont.name
			boldText: true
			textSize: 15
			onClicked: {
				timer.job = "XOR"
				timer.reset()
				timer.start()
			}
		}
	}

	Rectangle {
		id: mainArea
		width: root.width
		height: 480
		color: "transparent"
		y: buttonsRow.height * 2

		Row {
			id: n1BitsRow
			spacing: 4
			anchors.horizontalCenter: parent.horizontalCenter
			y: 50
			Repeater {
				id: n1Repeater
				model: 8
				Rectangle {
					width: 50; height: 50
					radius: 5
					color: nColor
					Behavior on color {
						ColorAnimation {
							duration: 400
							easing.type: Easing.InOutQuad
						}
					}
					Text {
						id: n1RepText
						text: n1Bits[index]
						anchors.centerIn: parent
						color: "white"
						font.bold: true
						font.pointSize: 16
					}
				}
			}
		}

		Row {
			id: n2BitsRow
			spacing: 4
			anchors.horizontalCenter: parent.horizontalCenter
			y: 2*n1BitsRow.y + n1BitsRow.height
			Repeater {
				id: n2Repeater
				model: 8
				Rectangle {
					width: 50; height: 50
					radius: 5
					color: nColor
					Behavior on color {
						ColorAnimation {
							duration: 400
							easing.type: Easing.InOutQuad
						}
					}

					Text {
						id: n2RepText
						text: n2Bits[index]
						anchors.centerIn: parent
						color: "white"
						font.bold: true
						font.pointSize: 16
					}
				}
			}
		}

		Rectangle {
			id: dividerLine
			width: n1BitsRow.width + 170
			height: 3
			x: n1InputRect.x
			y: n2BitsRow.y + n2BitsRow.height + 30
			color: "#9c9898"
			border.color: "#9c9898"
			radius: 2
		}

		Row {
			id: resultsRow
			spacing: 4
			anchors.horizontalCenter: parent.horizontalCenter
			y: n2BitsRow.y + n2BitsRow.height + 60
			Repeater {
				id: resultRepeater
				model: 8
				Rectangle {
					width: 50; height: 50
					radius: 5
					color: resultColor
					Behavior on color {
						ColorAnimation {
							duration: 400
							easing.type: Easing.InOutQuad
						}
					}
					Text {
						id: resultRepeaterText
						text: resultBits[index]
						anchors.centerIn: parent
						color: "white"
						font.bold: true
						font.pointSize: 16
					}
				}
			}
		}

		Text {
			id: resultLabel
			text: ""
			opacity: 0
			font.pointSize: 20
			x: n1InputRect.x
			y: resultsRow.y + resultsRow.height + 50
			Behavior on opacity {
				NumberAnimation {
					target: resultLabel
					property: "opacity"
					duration: 600
					easing.type: Easing.InOutQuad
				}
			}
		}

		MouseArea {
			anchors.fill: parent
			onClicked: resultLabel.opacity = 1
		}

		Rectangle {
			id: n1InputRect
			height: n1BitsRow.height
			x: n1BitsRow.x - 150
			anchors.verticalCenter: n1BitsRow.verticalCenter

			Text {
				id: n1Label
				width: implicitWidth
				text: "N1"
				font.pointSize: 18
				anchors.left: parent.left
				anchors.verticalCenter: parent.verticalCenter
			}

			TextField {
				id: textField1
				x: n1Label.width + 10
				anchors.verticalCenter: parent.verticalCenter
				validator: IntValidator {bottom: 0; top: 255}
				style: TextFieldStyle {
					textColor: "white"
					font {
						bold: true
						pointSize: 16
					}
					background: Rectangle {
						radius: 1
						color: "#c2bbbb"
						implicitWidth: 100
						implicitHeight: 40
						border.color: "#d9d1d1"
						border.width: 1
					}
				}
				onTextChanged: {
					timer.reset()
					updateBitsRow(1, textField1.text)
				}
			}
		}


		Rectangle {
			id: n2InputRect
			height: n2BitsRow.height
			x: n2BitsRow.x - 150
			anchors.verticalCenter: n2BitsRow.verticalCenter

			Text {
				id: n2Label
				width: implicitWidth
				text: "N2"
				font.pointSize: 18
				anchors.left: parent.left
				anchors.verticalCenter: parent.verticalCenter
			}

			TextField {
				id: textField2
				x: n2Label.width + 10
				anchors.verticalCenter: parent.verticalCenter
				validator: IntValidator {bottom: 0; top: 255}
				style: TextFieldStyle {
					textColor: "white"
					font {
						bold: true
						pointSize: 16
					}
					background: Rectangle {
						radius: 1
						color: "#c2bbbb"
						implicitWidth: 100
						implicitHeight: 40
						border.color: "#d9d1d1"
						border.width: 1
					}
				}
				onTextChanged: {
					timer.reset()
					updateBitsRow(2, textField2.text)
				}
			}
		}
	}
}
