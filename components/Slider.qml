import QtQuick 2.4
import QtQuick.Controls 1.3
import QtQuick.Controls.Styles 1.3

Item {
	id: root
	width: 150
	height: 30

	property int val: slider.value
	property int maxVal: slider.maximumValue
	property int minVal: slider.minimumValue
	property int step: slider.stepSize

	Slider {
		id: slider
		anchors.margins: 20
		stepSize: step
		maximumValue: maxVal
		minimumValue: minVal
//		value: val
		style: customStyle
//		Component.onCompleted: print(maxVal, minVal, val)
//		onValueChanged: print(value)
	}

	Component {
		id: customStyle
		SliderStyle {
			handle: Rectangle {
				width: 20
				height: 12
				antialiasing: true
				color: Qt.lighter("#468bb7", 1.2)
			}

			groove: Item {
				implicitHeight: root.height
				implicitWidth: root.width
				Rectangle {
					height: 8
					width: parent.width
					anchors.verticalCenter: parent.verticalCenter
					color: "#847878"
					opacity: 0.8
					Rectangle {
						antialiasing: true
						radius: 1
						color: "#1a0d0d"
						height: parent.height
						width: parent.width * control.value / control.maximumValue
					}
				}
			}
		}
	}
}
