import 'package:flutter/material.dart';
import 'package:karya/data/models/task.dart';
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
      future: Tasks().findById(widget.taskId),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return Scaffold(
              appBar: AppBar(
                title: const Text("Task Details"),
              ),
              body: FutureBuilder<Task>(
                future: Tasks().findById(widget.taskId),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return const Placeholder();
                  } else if (snapshot.hasError) {
                    return Text('${snapshot.error}');
                  }

                  // By default, show a loading spinner.
                  return const CircularProgressIndicator();
                },
              ),
              floatingActionButton: Visibility(
                visible: snapshot.hasData,
                child: FloatingActionButton(
                  onPressed: () async {
                    var result = await Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              TaskFormView(task: snapshot.data)),
                    );

                    setState(() {});
                  },
                  child: const Icon(Icons.edit),
                ),
              ));
        } else if (snapshot.hasError) {
          return Text('${snapshot.error}');
        }

        // By default, show a loading spinner.
        return const CircularProgressIndicator();
      },
    );
  }
}
