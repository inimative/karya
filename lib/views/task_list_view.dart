import 'package:flutter/material.dart';
import 'package:karya/data/models/task.dart';
import 'package:karya/data/services/Tasks.dart';
import 'package:karya/views/task_item_view.dart';

class TaskListView extends StatefulWidget {
  final DateTime startDate;
  final DateTime endDate;
  final void Function() refreshData;

  const TaskListView({
    super.key,
    required this.refreshData,
    required this.startDate,
    required this.endDate,
  });

  @override
  State<TaskListView> createState() => _TaskListViewState();
}

class _TaskListViewState extends State<TaskListView> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Task>>(
      future: TaskService.getAllByDateRange(widget.startDate, widget.endDate),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return Column(
            children: snapshot.data!
                .map((item) => TaskItemView(
                      item: item,
                      refreshData: widget.refreshData,
                    ))
                .toList(),
          );
        } else if (snapshot.hasError) {
          return Text('${snapshot.error}');
        }

        // By default, show a loading spinner.
        return const CircularProgressIndicator();
      },
    );
  }
}
