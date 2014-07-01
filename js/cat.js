var cats = ['agy6Lr6_460sa.gif','aQqVWoq_460sa.gif','aNeqxvG_460sa.gif','aVOdEdw_460sa.gif','aLKrnR6_460sa.gif','aZPvoX6_460sa.gif','aozmQXX_700ba.gif','anYDG6q_460sa.gif','ay5PZmb_460sa.gif','a6w3DN9_460sa.gif','aVOdjQO_460sa.gif','a44xpdA_460sa.gif','aM1WQxA_460sa.gif','av0DYXO_460sa.gif','apqdjm5_460sa.gif','a1Ax2xb_460sa.gif','ab5dBRO_460sa.gif','aOqRGyM_460sa.gif','azboLyK_460sa.gif','aXbdWKd_460sa.gif','aEwQzAG_460sa.gif','aNe2By3_460sa.gif','ab5EjP9_460sa.gif','aWZP036_460sa.gif','aEwQroO_460sa.gif','a5dyPnN_460sa.gif','aqmpRrM_460sa.gif','aLKbebV_460sa.gif','a6wjxyN_460sa.gif','awrYBEr_460sa.gif','aG9oBp5_460sa.gif','aPvrGMq_460sa.gif','aKzpnvQ_460sa.gif','aEwNDGK_460sa.gif','a8WQqd3_460sa.gif','anYWZE0_460sa.gif','aoz840w_460sa.gif','aG9o826_460sa.gif','aZPvZb6_460sa.gif','Funny-gif-stretching-kitty.gif','aozdLAX_460sa.gif','aLKWoAP_460sa.gif','aLKXLzA_460sa_v1.gif','aYbd8P2_460sa.gif','aVORMgP_460sa.gif','ajrdQrx_460sa.gif','a09xngZ_460sa.gif','aD0NDOB_460sa.gif','aVO1LQv_460sa.gif','aAYZyBZ_460sa.gif','a2Nj2YZ_460sa.gif','ab5EneL_460sa.gif','aVOd1gy_460sa.gif','aD0rgmZ_460sa.gif','axNArv1_460sa.gif','aWZP0A3_460sa.gif','aozdO8m_460sa.gif','aWZdL9n_460sa.gif','a5dDvAr_460sa.gif','amXbdWj_460sa.gif'];
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
