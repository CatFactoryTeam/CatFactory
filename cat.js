var cats = [1,2,3,4,5,6,7,8],
    used = [];

window.onload = function() {
	ncat();
}	

document.getElementById('ncat').onclick = function() {
	ncat();
}

// A 'clever' next random cat
function ncat() {
	
	if (cats.length == 0)
		new_start();
	
	var cat = document.getElementById('cat');
	cat.src = 'cats/' + cats[0];
	
	used.push(cats.shift());
}

// When each cats have been used
function new_start() {
	
	// TODO : shuffle array
	cats = used;
	used = [];
}
