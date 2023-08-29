import 'package:flutter/material.dart';
import 'package:karya/data/models/task.dart';
import 'package:karya/data/services/Tasks.dart';
import 'package:karya/views/task_details_view.dart';

class TaskItemView extends StatefulWidget {
  final String itemId;

  const TaskItemView({super.key, required this.itemId});

  @override
  State<TaskItemView> createState() => _TaskItemViewState();
}

class _TaskItemViewState extends State<TaskItemView> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: TaskService.findById(widget.itemId),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return ListTile(
              trailing: getTrailingWidget(snapshot),
              title: Text(snapshot.data!.name),
              subtitle: Text(snapshot.data!.description),
              onTap: () async {
                await Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          TaskDetailsView(taskId: snapshot.data!.id)),
                );

                setState(() {});
              },
            );
          } else if (snapshot.hasError) {
            return Text('${snapshot.error}');
          }

          // By default, show a loading spinner.
          return const CircularProgressIndicator();
        });
  }

  Widget getTrailingWidget(AsyncSnapshot<Task> snapshot) {
    if (snapshot.data!.subTasks.isEmpty) {
      return Checkbox(
          value: snapshot.data!.completed,
          onChanged: (bool? value) async {
            snapshot.data!.completed = !snapshot.data!.completed;
            await TaskService.upsert(snapshot.data!);
            setState(() {});
          });
    }
    return const Padding(
      padding: EdgeInsets.all(8.0),
      child: Icon(Icons.chevron_right, size: 32),
    );
  }
}
