import QtQuick 2.2
import QtQuick.Controls 1.2
import "./components"

ApplicationWindow {
    visible: true
	width: 1200
	height: 700

    Rectangle {
        color: "#212126"
        anchors.fill: parent
    }

	toolBar: BorderImage {
		border.bottom: 8
		source: "images/toolbar.png"
		width: parent.width
		height: 100

        Rectangle {
            id: backButton
            width: opacity ? 60 : 0
            anchors.left: parent.left
			anchors.leftMargin: 20
            opacity: stackView.depth > 1 ? 1 : 0
            anchors.verticalCenter: parent.verticalCenter
			antialiasing: true
            height: 60
            radius: 4
            color: backmouse.pressed ? "#222" : "transparent"
            Behavior on opacity { NumberAnimation{} }
            Image {
                anchors.verticalCenter: parent.verticalCenter
                source: "images/navigation_previous_item.png"
            }
			MouseArea {
                id: backmouse
                anchors.fill: parent
				anchors { leftMargin: -20; rightMargin: -110; topMargin: -20; bottomMargin: -20 }
                onClicked: stackView.pop()
            }
        }

        Text {
            font.pixelSize: 42
            Behavior on x { NumberAnimation{ easing.type: Easing.OutCubic} }
            x: backButton.x + backButton.width + 20
            anchors.verticalCenter: parent.verticalCenter
            color: "white"
			text: stackView.depth > 1 ? "Back" : "Algorithm Simulator"
        }
    }

    ListModel {
		id: pageModel
        ListElement {
			title: "Sorting"
			page: "content/sorting/SortMenu.qml"
        }
        ListElement {
			title: "BitWise"
			page: "content/bitmask/BitWise.qml"
        }
        ListElement {
			title: "Graphs"
			page: "content/graph/InOrder.qml"
        }
        ListElement {
			title: "Data Structures"
			page: "content/datastructure/Stack.qml"
        }
        ListElement {
            title: "TextInput"
            page: "content/TextInputPage.qml"
        }
        ListElement {
            title: "List"
            page: "content/ListPage.qml"
        }
    }

    StackView {
        id: stackView
        anchors.fill: parent
        // Implements back key navigation
        focus: true
		Keys.onReleased: if (event.key === Qt.Key_Back && stackView.depth > 1) {
							 stackView.pop();
							 event.accepted = true;
						 }

        initialItem: Item {
			width: parent.width
			height: parent.height

			ListView {
				width: parent.width
				height: parent.height
				model: pageModel
				anchors.centerIn: parent
				delegate: MenuDelegate {
					text: title
					onClicked: {
						stackView.push(Qt.resolvedUrl(page))
					}
				}
			}
        }
    }
}
