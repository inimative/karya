import 'package:karya/data/models/task.dart';

class Tasks {
  static final Tasks _singleton = Tasks._internal();

  factory Tasks() {
    return _singleton;
  }

  Tasks._internal();

  late List<Task> _tasks = [];

  Future<List<Task>> get tasks => Future.value(_tasks);

  Future<List<Task>> load() async {
    List<Task> tasks = [
      Task("abc", "Somehting", "with description", DateTime.now(), false, [],
          "project1"),
      Task("abc1", "Somehting", "with description", DateTime.now(), false, [],
          "project1"),
      Task("abc2", "Somehting", "with description", DateTime.now(), false, [],
          "project1"),
      Task("abc3", "Somehting", "with description", DateTime.now(), false, [],
          "project1"),
      Task("abc4", "Somehting", "with description", DateTime.now(), false, [],
          "project1"),
      Task("abc5", "Somehting", "with description", DateTime.now(), false, [],
          "project1"),
      Task("abc6", "Somehting", "with description", DateTime.now(), false, [],
          "project1"),
      Task("abc7", "Somehting", "with description", DateTime.now(), false, [],
          "project1"),
      Task("abc8", "Somehting", "with description", DateTime.now(), false, [],
          "project1"),
      Task("abc9", "Somehting", "with description", DateTime.now(), false, [],
          "project1"),
      Task("abc9", "Somehting", "with description", DateTime.now(), false, [],
          "project1"),
      Task("abc9", "Somehting", "with description", DateTime.now(), false, [],
          "project1"),
      Task("abc9", "Somehting", "with description", DateTime.now(), false, [],
          "project1"),
      Task("abc9", "Somehting", "with description", DateTime.now(), false, [],
          "project1"),
      Task("abc9", "Somehting", "with description", DateTime.now(), false, [],
          "project1"),
      Task("abc9", "Somehting", "with description", DateTime.now(), false, [],
          "project1"),
      Task("abc9", "Somehting", "with description", DateTime.now(), false, [],
          "project1"),
      Task("abc9", "Somehting", "with description", DateTime.now(), false, [],
          "project1"),
      Task("abc9", "Somehting", "with description", DateTime.now(), false, [],
          "project1"),
      Task("abc9", "Somehting", "with description", DateTime.now(), false, [],
          "project1"),
      Task("abc9", "Somehting", "with description", DateTime.now(), false, [],
          "project1"),
      Task("abc9", "Somehting", "with description", DateTime.now(), false, [],
          "project1"),
      Task("abc9", "Somehting", "with description", DateTime.now(), false, [],
          "project1"),
      Task("abc9", "Somehting", "with description", DateTime.now(), false, [],
          "project1"),
      Task("abc9", "Somehting", "with description", DateTime.now(), false, [],
          "project1"),
      Task("abc9", "Somehting", "with description", DateTime.now(), false, [],
          "project1"),
    ];

    _tasks = tasks;
    return Future.value(tasks);
  }

  void upsert(Task t) {
    var i = _tasks.indexWhere((element) => element.id == t.id);
    if (i < 0) {
      _tasks.add(t);
    } else {
      _tasks[i] = t;
    }
  }

  Future<Task> findById(String taskId) async {
    var t = _tasks.firstWhere((element) => element.id == taskId);
    return Future.value(t);
  }
}
