var cats = ['aLKWoAP_460sa.gif','aKzpnvQ_460sa.gif','aLKrnR6_460sa.gif','aAYZyBZ_460sa.gif','aoz840w_460sa.gif','ay5PZmb_460sa.gif','aG9o826_460sa.gif','aZPvZb6_460sa.gif','ab5dBRO_460sa.gif','ab5EjP9_460sa.gif','anYDG6q_460sa.gif','aQqVWoq_460sa.gif','a44xpdA_460sa.gif','aZPvoX6_460sa.gif','aozdO8m_460sa.gif','Funny-gif-stretching-kitty.gif','aVOdjQO_460sa.gif','ajrdQrx_460sa.gif','aLKbebV_460sa.gif','aVORMgP_460sa.gif','aOqRGyM_460sa.gif','aLKXLzA_460sa_v1.gif','ab5EneL_460sa.gif','aPvrGMq_460sa.gif','a5dDvAr_460sa.gif','awrYBEr_460sa.gif','a09xngZ_460sa.gif','aozmQXX_700ba.gif','aVOdEdw_460sa.gif','a6wjxyN_460sa.gif','aEwQzAG_460sa.gif','aWZdL9n_460sa.gif'];
var used = [];

window.onload = function() {
	cats = shuffle(cats);
	ncat();
}

// A 'clever' next random cat
function ncat() {

	if (cats.length == 0)
		new_start();
	
	var wrp = document.getElementById('wrap');
	wrp.removeChild(wrp.firstChild);
	
	var cat = document.createElement("img");
	cat.setAttribute('src', 'cats/' + cats[0]);
	cat.setAttribute('class', 'img-responsive img-circle');
	cat.setAttribute('id', 'cat');
		
	wrp.appendChild(cat);

	used.push(cats.shift());
}

// When each cats have been used
function new_start() {

	// TODO : shuffle array
	cats = shuffle(used);
	used = [];
}

//+ Jonas Raoni Soares Silva
//@ http://jsfromhell.com/array/shuffle [v1.0]
function shuffle(o) { //v1.0
    for(var j, x, i = o.length; i; j = Math.floor(Math.random() * i), x = o[--i], o[i] = o[j], o[j] = x);
    return o;
};