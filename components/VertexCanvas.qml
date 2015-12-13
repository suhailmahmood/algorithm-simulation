import QtQuick 2.4

Rectangle {
	id: canvas
	width: 700
	height: 530
	color: "transparent"

	property var vertices: [vertex1, vertex2, vertex3, vertex4, vertex5, vertex6, vertex7, vertex8, vertex9, vertex10]
	property var edges: [edge1, edge2, edge3, edge4, edge5, edge6, edge7, edge8, , edge9]

	function selectVertex(n, visit) {
		if(n >= 0) {
			if(visit) {
				vertices[n].status = 2
			}
			else {
				for(var i=0; i<vertices.length; i++) {
					if(i === n)
						vertices[i].status = 1
					else
						vertices[i].status = vertices[i].status === 2 ? 2 : 0
				}
			}
		}
		else {
			for(i=0; i<vertices.length; i++)
				vertices[i].status = 0
		}
	}

	Vertex { id: vertex1; x: 320; y: 8 }
	Vertex { id: vertex2; x: 219; y: 118 }
	Vertex { id: vertex3; x: 423; y: 118 }
	Vertex { id: vertex4; x: 157; y: 230 }
	Vertex { id: vertex5; x: 277; y: 232 }
	Vertex { id: vertex6; x: 370; y: 230 }
	Vertex { id: vertex7; x: 509; y: 227 }
	Vertex { id: vertex8; x: 314; y: 346 }
	Vertex { id: vertex10; x: 246; y: 456 }
	Vertex { id: vertex9; x: 450; y: 342 }

	Edge { id: edge1; x: 296; y: 90; antialiasing: true; length: 88; angle: 134 }
	Edge { id: edge3; x: 210; y: 200; antialiasing: true; angle: 121; length: 70 }
	Edge { id: edge4; x: 283; y: 203; antialiasing: true; angle: 60; length: 70	}
	Edge { id: edge2; x: 404; y: 91; antialiasing: true; clip: false; visible: true; angle: 44; length: 92 }
	Edge { id: edge5; x: 417; y: 203; antialiasing: true; angle: 121; length: 70 }
	Edge { id: edge6; x: 499; y: 199; antialiasing: true; angle: 50; length: 78 }
	Edge { id: edge7; x: 366; y: 317; antialiasing: true; angle: 121; length: 70 }
	Edge { id: edge8; x: 441; y: 315; antialiasing: true; angle: 50; length: 78 }
	Edge { id: edge9; x: 306; y: 430; antialiasing: true; angle: 121; length: 70 }
}
