function getNRandom(N) {
	var array = []
	if(!N)
		N = Math.floor(Math.random() * 6 + 5)

	for(var i=0; i<N; i++) {
		array[i] = Math.floor(Math.random() * 95) + 5
	}
	return array
}
