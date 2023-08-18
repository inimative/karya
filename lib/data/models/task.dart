import 'package:uuid/uuid.dart';

class SubTask {
  String id;
  String name;
  String description;
  bool completed;

  SubTask(this.id, this.name, this.description, this.completed);

  static SubTask fromDocumentData(Map<String, dynamic> data) {
    return SubTask(
        data['id'], data['name'], data['description'], data['completed']);
  }
}

class Task {
  String id;
  String name;
  String description;
  DateTime schedule;
  bool completed;
  List<SubTask> subTasks;
  String? projectId;

  Task(this.id, this.name, this.description, this.schedule, this.completed,
      this.subTasks, this.projectId);

  static Task newTask() {
    return Task(const Uuid().v4(), '', '', DateTime.now(), false, [], '');
  }

  static Task fromDocumentData(Map<String, dynamic> data) {
    return Task(
      data['id'],
      data['name'],
      data['description'],
      DateTime.fromMillisecondsSinceEpoch(data['schedule']),
      data['completed'],
      data['subTasks'].isEmpty
          ? []
          : data['subTasks'].map((e) => SubTask.fromDocumentData(e)).toList(),
      data['projectId'],
    );
  }

  Map<String, dynamic> toDocumentData() {
    return <String, dynamic>{
      "id": id,
      "name": name,
      "description": description,
      "schedule": schedule.millisecondsSinceEpoch,
      "completed": completed,
      "subTasks": subTasks,
      "projectId": projectId
    };
  }
}
