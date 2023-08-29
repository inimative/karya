import 'package:dart_date/dart_date.dart';
import 'package:flutter/material.dart';
import 'package:karya/data/models/task.dart';
import 'package:karya/views/task_form_view.dart';
import 'package:karya/views/task_list_view.dart';

class TodayPage extends StatefulWidget {
  const TodayPage({super.key});

  @override
  State<TodayPage> createState() => _TodayPageState();
}

class _TodayPageState extends State<TodayPage> {
  Future<void> _navigateToNewTaskScreen(BuildContext context) async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => TaskFormView(task: Task.newTask())),
    );

    setState(() {});
  }

  Widget getBody(BuildContext context) {
    return ListView(
      children: [
        Container(
          color: Theme.of(context).colorScheme.secondary.withOpacity(0.3),
          padding: const EdgeInsets.fromLTRB(15, 10, 15, 10),
          child: Text("Today", style: Theme.of(context).textTheme.titleLarge),
        ),
        TaskListView(
          refreshData: () {
            setState(() {});
          },
          startDate: DateTime.now(),
          endDate: DateTime.now(),
        ),
        Container(
          color: Theme.of(context).colorScheme.secondary.withOpacity(0.3),
          padding: const EdgeInsets.fromLTRB(15, 10, 15, 10),
          child:
              Text("Tomorrow", style: Theme.of(context).textTheme.titleLarge),
        ),
        TaskListView(
          refreshData: () {
            setState(() {});
          },
          startDate: DateTime.now().add(const Duration(days: 1)),
          endDate: DateTime.now().add(const Duration(days: 1)),
        ),
        Container(
          color: Theme.of(context).colorScheme.secondary.withOpacity(0.3),
          padding: const EdgeInsets.fromLTRB(15, 10, 15, 10),
          child:
              Text("Upcoming", style: Theme.of(context).textTheme.titleLarge),
        ),
        TaskListView(
          refreshData: () {
            setState(() {});
          },
          startDate: DateTime.now().add(const Duration(days: 2)),
          endDate: DateTime.now().add(const Duration(days: 2)).endOfWeek,
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Today"),
      ),
      body: getBody(context),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _navigateToNewTaskScreen(context);
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}

