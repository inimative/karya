import 'package:flutter/material.dart';
import 'package:karya/data/models/task.dart';
import 'package:karya/views/task_form_view.dart';
import 'package:karya/views/task_list_view.dart';

import '../data/services/Tasks.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Future<void> _navigateToNewTaskScreen(BuildContext context) async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => TaskFormView(task: Task.newTask())),
    );

    setState(() {});
  }

  Widget getBody() {
    return FutureBuilder<List<Task>>(
      future: TaskService.load(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return TaskListView(
              items: snapshot.data ?? [],
              refreshData: () {
                setState(() {});
              });
        } else if (snapshot.hasError) {
          return Text('${snapshot.error}');
        }

        // By default, show a loading spinner.
        return const CircularProgressIndicator();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Today"),
      ),
      body: Center(
        child: getBody(),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _navigateToNewTaskScreen(context);
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
