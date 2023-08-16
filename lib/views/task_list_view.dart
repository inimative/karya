import 'package:flutter/material.dart';
import 'package:karya/data/models/task.dart';
import 'package:karya/views/task_details_view.dart';

class TaskListView extends StatefulWidget {
  final List<Task> items;
  final void Function() refreshData;

  const TaskListView({super.key, required this.items, required this.refreshData});

  @override
  State<TaskListView> createState() => _TaskListViewState();
}

class _TaskListViewState extends State<TaskListView> {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: widget.items.length,
      itemBuilder: (context, index) {
        final item = widget.items[index];

        return ListTile(
          trailing:
              Checkbox(onChanged: (bool? value) {
                setState(() {
                  item.completed = !item.completed;
                });
              }, value: item.completed),
          title: Text(item.name),
          subtitle: Text(item.description),
          onTap: () async {
            await Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => TaskDetailsView(taskId: item.id)),
            );

            widget.refreshData();
          },
        );
      },
    );
  }
}
