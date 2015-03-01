function getNRandom(N) {
	var array = []

	for(var i=0; i<N; i++) {
		array[i] = Math.floor(Math.random() * 95) + 5
	}
	return array
}
