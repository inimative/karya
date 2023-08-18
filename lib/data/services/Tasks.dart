import 'package:cloud_firestore/cloud_firestore.dart';
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
    print("loading");
    _tasks = (await FirebaseFirestore.instance.collection("tasks").get())
        .docs
        .map((e) => Task.fromDocumentData(e.data()))
        .toList();
    return Future.value(tasks);
  }

  Future<void> upsert(Task t) async {
    var docRef = FirebaseFirestore.instance.collection("tasks").doc(t.id);
    await docRef.set(t.toDocumentData());
  }

  Future<Task> findById(String taskId) async {
    var docRef = FirebaseFirestore.instance.collection("tasks").doc(taskId);
    var snapshot = await docRef.get();
    if (snapshot.exists) {
      return Task.fromDocumentData(snapshot.data()!);
    }
    return Future.error("error");
  }
}
