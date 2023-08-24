import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:karya/data/models/task.dart';

class TaskService {
  static Future<List<Task>> load() async {
    var tasks = (await FirebaseFirestore.instance.collection("tasks").get())
        .docs
        .map((e) => Task.fromDocumentData(e.data()))
        .toList();
    return Future.value(tasks);
  }

  static Future<void> upsert(Task t) async {
    var docRef = FirebaseFirestore.instance.collection("tasks").doc(t.id);
    await docRef.set(t.toDocumentData());
  }

  static Future<Task> findById(String taskId) async {
    var docRef = FirebaseFirestore.instance.collection("tasks").doc(taskId);
    var snapshot = await docRef.get();
    if (snapshot.exists) {
      return Task.fromDocumentData(snapshot.data()!);
    }
    return Future.error("error");
  }

  static Future<void> updateSubTask(String taskId, SubTask subTask) async {
    var docRef = FirebaseFirestore.instance.collection("tasks").doc(taskId);
    await docRef.update({"subTasks.${subTask.id}": subTask.toDocumentData()});
  }
}
