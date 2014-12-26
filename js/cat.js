var used = [];

window.onload = function() {
	cats = shuffle(cats);
	ncat();
	// Set canvas
	canvas();
}

// A 'clever' next random cat
function ncat() {
	if (cats.length == 0) {
		new_start();
	}

	var wrp = document.getElementById('wrap');
	wrp.removeChild(wrp.firstChild);

	var cat = document.createElement("img");
	cat.setAttribute('src', 'cats/' + cats[0]);
	cat.setAttribute('class', 'circular ui image');
	cat.setAttribute('id', 'cat');

	wrp.appendChild(cat);

	used.push(cats.shift());
}

// When each cats have been used
function new_start() {
	cats = shuffle(used);
	used = [];
}

//+ Jonas Raoni Soares Silva
//@ http://jsfromhell.com/array/shuffle [v1.0]
function shuffle(o) { //v1.0
	for(var j, x, i = o.length; i; j = Math.floor(Math.random() * i), x = o[--i], o[i] = o[j], o[j] = x);
	return o;
};

document.onkeydown = function(ev) {
	if (ev.keyCode == 78) ncat();
};
