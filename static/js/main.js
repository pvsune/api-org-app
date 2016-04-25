var app = angular.module("noteApp", []);
app.controller("noteCtrl", function ($scope, $http) {
  get_notes();

  $scope.filter_options = [
    { name: "Notes", value: 0 },
    { name: "ToDos", value: 1 }
  ];

  $scope.submit = function () {
    NProgress.start();
    var data = { note: $scope.new_note, is_todo: 0, is_done: 0 };

    var req = $http.put("http://localhost:5000/notes", data);
    req.success(function (response) {
      $scope.notes = response;
    });

    req.finally(function () {
      NProgress.done();
      get_notes();
    });
  }

  $scope.make_todo = function (x) {
    x.is_done = 0;
    x.is_todo = 1;
    return $scope.update(x, 1);
  }

  $scope.make_note = function (x) {
    x.is_done = 0;
    x.is_todo = 0;
    return $scope.update(x, 1);
  }

  $scope.update = function (x, force_reset) {
    NProgress.start();

    if (!force_reset) {
      x.is_done = 1 - x.is_done;
    }

    if (x.is_editing) {
      x.note = $scope.note;
      $scope.note = '';
    }

    delete x["is_editing"];

    var id = x.id;
    var req = $http.post("http://localhost:5000/notes/"+id, x);
    req.success(function (response) { console.log(x) });
    req.finally(function () { NProgress.done() });

    return x;
  }

  $scope.edit = function (x) {
    for (y in $scope.notes) { $scope.notes[y].is_editing = 0 }
    x.is_editing = 1;

    $scope.note = x.note;
    return x;
  }

  $scope.delete = function (x) {
    NProgress.start();

    var id = x.id;
    var req = $http.delete("http://localhost:5000/notes/"+id);
    req.success(function (response) { console.log(x) });
    req.finally(function () { NProgress.done() });

    get_notes();
  }

  // Helper functions
  function get_notes () {
    NProgress.start();

    var req = $http.get("http://localhost:5000/notes");
    req.success(function (response) {
      $scope.notes = response;
    });
    req.finally(function () { NProgress.done() });
  }
});
