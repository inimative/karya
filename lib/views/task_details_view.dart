import 'package:dart_date/dart_date.dart';
import 'package:flutter/material.dart';
import 'package:karya/data/models/task.dart';
import 'package:karya/views/sub_task_list_view.dart';
import 'package:karya/views/task_form_view.dart';

import '../data/services/Tasks.dart';

class TaskDetailsView extends StatefulWidget {
  final String taskId;

  const TaskDetailsView({super.key, required this.taskId});

  @override
  State<TaskDetailsView> createState() => _TaskDetailsViewState();
}

class _TaskDetailsViewState extends State<TaskDetailsView> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Task>(
      future: TaskService().findById(widget.taskId),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return getTaskDetailsPage(snapshot, context);
        } else if (snapshot.hasError) {
          return Text('${snapshot.error}');
        }

        // By default, show a loading spinner.
        return const CircularProgressIndicator();
      },
    );
  }

  Scaffold getTaskDetailsPage(
      AsyncSnapshot<Task> snapshot, BuildContext context) {
    var textTheme = Theme.of(context).textTheme;
    return Scaffold(
        appBar: AppBar(
          title: const Text("Task Details"),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ListTile(
                title: Text(snapshot.data!.name, style: textTheme.titleLarge),
                subtitle: Text(snapshot.data!.description),
                trailing: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      snapshot.data!.schedule.format("E"),
                      style: textTheme.titleMedium,
                    ),
                    Text(
                      snapshot.data!.schedule.format("MMM y"),
                      style: textTheme.labelSmall,
                    ),
                  ],
                ),
              ),
              const Divider(
                thickness: 2,
              ),
              Expanded(child: SubTaskListView(items: snapshot.data!.subTasks, taskId: widget.taskId))
            ],
          ),
        ),
        floatingActionButton: Visibility(
          visible: snapshot.hasData,
          child: FloatingActionButton(
            onPressed: () async {
              var result = await Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => TaskFormView(task: snapshot.data!)),
              );

              setState(() {});
            },
            child: const Icon(Icons.edit),
          ),
        ));
  }
}
