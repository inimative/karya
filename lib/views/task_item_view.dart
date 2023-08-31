import 'package:flutter/material.dart';
import 'package:karya/data/models/task.dart';
import 'package:karya/data/services/Tasks.dart';
import 'package:karya/views/task_details_view.dart';

class TaskItemView extends StatelessWidget {
  final Task item;
  final void Function() refreshData;

  const TaskItemView(
      {super.key, required this.item, required this.refreshData});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: getTrailingWidget(),
      title: Text(item.name),
      subtitle: Text(item.description),
      onTap: () async {
        await Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => TaskDetailsView(taskId: item.id)),
        );

        refreshData();
      },
    );
  }

  Widget getTrailingWidget() {
    if (item.subTasks.isEmpty) {
      return Checkbox(
          value: item.completed,
          onChanged: (bool? value) async {
            item.completed = !item.completed;
            await TaskService.upsert(item);
            refreshData();
          });
    }
    return const Padding(
      padding: EdgeInsets.all(8.0),
      child: Icon(Icons.chevron_right, size: 32),
    );
  }
}
