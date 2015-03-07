var app = angular.module('cat', []);

app.controller('Ctrl', function($scope, $http) {
  $scope.waitingGif = { link: 'img/waiting.gif' };

  // By default put a local waiting gif
  $scope.cats = [$scope.waitingGif];
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
    $scope.cats.shift();
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
});
