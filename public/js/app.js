var app = angular.module('cat', []);

app.controller('Meow', function($scope, $http) {
  // By default put a local waiting gif
  $scope.cats = [{ link: 'img/waiting.gif' }];
  $scope.used = [];
  $scope.restApi = "https://catfactory-api.herokuapp.com";

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

    // Stuff below is...
    // Not very sexy ! But it works well on every browsers
    // @todo Find a lovely way to "stream" GIF (avoid GIF restart when download is done)
    var wrp = document.getElementById('wrap');
    while (wrp.firstChild) {
      wrp.removeChild(wrp.firstChild);
    }

    var cat = document.createElement('img');
    cat.setAttribute('src', $scope.cats[0].link);
    cat.setAttribute('class', 'circular ui image');
    cat.setAttribute('id', 'cat');

    wrp.appendChild(cat);
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
