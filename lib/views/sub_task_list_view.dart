import 'package:flutter/material.dart';
import 'package:karya/data/models/task.dart';
import 'package:karya/data/services/Tasks.dart';

class SubTaskListView extends StatefulWidget {
  final Map<String, SubTask> items;

  final String taskId;

  const SubTaskListView(
      {super.key, required this.items, required this.taskId});

  @override
  State<SubTaskListView> createState() => _SubTaskListViewState();
}

class _SubTaskListViewState extends State<SubTaskListView> {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: widget.items.length,
      itemBuilder: (context, index) {
        String key = widget.items.keys.elementAt(index);
        final SubTask item = widget.items[key]!;

        return ListTile(
          trailing: Checkbox(
              onChanged: (bool? value) async {
                item.completed = value ?? false;
                await TaskService.updateSubTask(widget.taskId, item);
                setState(() {});
              },
              value: item.completed),
          title: Text(item.name),
        );
      },
    );
  }
}
