pragma Singleton

import QtQuick 2.3

QtObject {
	id: fontLoader

	property FontLoader papyrusFont: FontLoader {
		name: "Papyrus"
		source: "../fonts/Papyrus.ttf"
	}

	property FontLoader algerianFont: FontLoader {
		name: "Algerian"
		source: "../fonts/Algerian.ttf"
	}
}
