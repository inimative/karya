import 'package:flutter/material.dart';
import 'package:karya/data/models/task.dart';
import 'package:karya/views/task_list_view.dart';

import '../data/services/Tasks.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {



  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Task>>(
      future: Tasks().tasks,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return TaskListView(items: snapshot.data??[]);
        } else if (snapshot.hasError) {
          return Text('${snapshot.error}');
        }

        // By default, show a loading spinner.
        return const CircularProgressIndicator();
      },
    );
  }

  @override
  void initState() {
    super.initState();
    Tasks().load();
  }
}
