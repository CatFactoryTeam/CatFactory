var app = angular.module('cat', []);

app.controller('Ctrl', function($scope, $http) {
  $scope.waitingGif = { link: 'img/waiting.gif' };

  // By default put a local waiting gif
  $scope.cats = [$scope.waitingGif];
  $scope.used = [];
  $scope.restApi = "http://localhost:9000";

  /**
   * Retrieve cats from CatRest
   */
  $scope.retrieveCats = function() {
    $http.get($scope.restApi + "/cats")
      .success(function(data, status, headers, config) {
          $scope.cats = $scope.shuffle(data.data);
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
