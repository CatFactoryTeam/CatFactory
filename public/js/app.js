var app = angular.module('cat', []);

app.controller('MeowCtrl', function($http) {
  ctrl = this;
  this.ready = false;
  this.error = false;

  this.cats = [];
  this.used = [];
  this.restApi = 'https://catfactory-api.herokuapp.com';

  /**
   * Retrieve cats from CatApi (directly called)
   */
  this.retrieveCats = function() {
    $http.get(ctrl.restApi + '/cats')
      .success(function(data) {
        ctrl.cats = ctrl.shuffle(data.data);
        ctrl.meow();
        ctrl.ready = true;
      })
      .error(function() {
        ctrl.error = true;
      });
  }();

  /**
   * Meow! Call the next cat
   */
  this.meow = function() {
    if (ctrl.cats.length == 0) ctrl.freshStart();

    ctrl.used.push(ctrl.cats.shift());

    document.getElementsByClassName('wrap')[0].innerHTML =
      '<img src="' + ctrl.cats[0].link + '" id="cat" class="circular ui image"/>';
  }

  /**
   * A fresh start, when all cats have been seen
   */
  this.freshStart = function() {
    ctrl.cats = shuffle(ctrl.used);
    ctrl.used = [];
  }

  /**
   * Shuffle an array
   * @author Jonas Raoni Soares Silva
   * http://jsfromhell.com/array/shuffle
   */
  this.shuffle = function(o) {
    for(var j, x, i = o.length; i; j = Math.floor(Math.random() * i), x = o[--i], o[i] = o[j], o[j] = x);
    return o;
  };

  /**
   * Meow when pressing 'n'
   */
  this.onKeyDown = function(ev) {
    if (ev.keyCode == 78) ctrl.meow();
  };
});
