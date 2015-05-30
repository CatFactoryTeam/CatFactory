var app = angular.module('cat', []);

app.controller('Meow', function($scope, $http) {
  $scope.ready = false;
  $scope.error = false;

  $scope.cats = [];
  $scope.used = [];
  $scope.restApi = 'https://catfactory-api.herokuapp.com';

  /**
   * Retrieve cats from CatApi (directly called)
   */
  $scope.retrieveCats = function() {
    $http.get($scope.restApi + '/cats')
      .success(function(data) {
        $scope.cats = $scope.shuffle(data.data);
        $scope.meow();
        $scope.ready = true;
      })
      .error(function() {
        $scope.error = true;
      });
  }();

  /**
   * Meow ! Call the next cat
   */
  $scope.meow = function() {
    if ($scope.cats.length == 0) $scope.freshStart();

    $scope.used.push($scope.cats.shift());

    document.getElementsByClassName('wrap')[0].innerHTML =
      '<img src="' + $scope.cats[0].link + '" id="cat" class="circular ui image"/>';
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
