var cats = ['aWZdL9n_460sa.gif','aozmQXX_700ba.gif','aZPvZb6_460sa.gif','aLKrnR6_460sa.gif','ab5EjP9_460sa.gif','aLKXLzA_460sa_v1.gif','aKzpnvQ_460sa.gif','aVOdEdw_460sa.gif','aLKWoAP_460sa.gif','aAYZyBZ_460sa.gif','aVORMgP_460sa.gif','aoz840w_460sa.gif','aZPvoX6_460sa.gif','aPvrGMq_460sa.gif','ay5PZmb_460sa.gif','aG9o826_460sa.gif','a5dDvAr_460sa.gif','aQqVWoq_460sa.gif','aOqRGyM_460sa.gif','aEwQzAG_460sa.gif','aVOdjQO_460sa.gif','anYDG6q_460sa.gif','a6wjxyN_460sa.gif','ab5EneL_460sa.gif','aozdO8m_460sa.gif','awrYBEr_460sa.gif','a44xpdA_460sa.gif','aLKbebV_460sa.gif'];
var used = [];

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