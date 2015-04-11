var app = angular.module('cat', []);

app.controller('Meow', function($scope, $http) {
  $ready = false;
  $scope.cats = [];
  $scope.used = [];
  $scope.restApi = "https://catfactory-api.herokuapp.com";

  /**
   * Retrieve cats from CatRest
   */
  $scope.retrieveCats = function() {
    $http.get($scope.restApi + "/cats")
      .success(function(data, status, headers, config) {
        $scope.cats = $scope.shuffle(data.data);
        $scope.meow();
        $scope.ready = true;
      })
      .error(function(data, status, headers, config) {

      });
  }();

  /**
   * Meow ! Call the next cat
   */
  $scope.meow = function() {
    if ($scope.cats.length == 0) $scope.freshStart();

    $scope.used.push($scope.cats.shift());

    document.getElementById('wrap').innerHTML = '<video autoplay="true" loop="true" muted="" class="circular ui image">' +
      '<source type="video/webm" src="' + $scope.cats[0].webm +'"><source type="video/mp4" src="' + $scope.cats[0].mp4 +'"></video>';
  }

  /**
   * A fresh start, when all cats have been seen
   */
  $scope.freshStart = function() {
    $scope.cats = shuffle($scope.used);
    $scope.used = [];
  }

  /**
   * Shuffle an array
   * @author Jonas Raoni Soares Silva
   * http://jsfromhell.com/array/shuffle
   */
  $scope.shuffle = function(o) {
    for(var j, x, i = o.length; i; j = Math.floor(Math.random() * i), x = o[--i], o[i] = o[j], o[j] = x);
    return o;
  };

  /**
   * Meow when pressing 'n'
   */
  $scope.onKeyDown = function(ev) {
    if (ev.keyCode == 78) $scope.meow();
  };
});
