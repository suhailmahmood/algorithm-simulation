import QtQuick 2.4
import QtQuick.Controls 1.3
import QtQuick.Controls.Styles 1.3

Item {
	id: root
	width: 150
	height: 30

	property alias value: slider.value
	property alias maximumValue: slider.maximumValue
	property alias minimumValue: slider.minimumValue
	property alias stepSize: slider.stepSize
	property color sliderColor

	Slider {
		id: slider
		anchors.margins: 20
		style: customStyle
	}

	Component {
		id: customStyle
		SliderStyle {
			handle: Rectangle {
				width: 20
				height: 12.5
				antialiasing: true
				color: sliderColor
			}

			groove: Item {
				id: item
				implicitHeight: root.height
				implicitWidth: root.width
				Rectangle {
					id: groove
					height: 8
					width: parent.width
					anchors.verticalCenter: parent.verticalCenter
					color: "#847878"
					opacity: 0.8

					Rectangle {
						antialiasing: true
						radius: 1
						color: Qt.lighter(root.sliderColor, 0.5)
						height: parent.height
						width: parent.width * control.value / control.maximumValue
					}
				}
			}
		}
	}
}
