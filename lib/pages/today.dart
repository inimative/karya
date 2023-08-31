import 'package:dart_date/dart_date.dart';
import 'package:flutter/material.dart';
import 'package:karya/data/models/task.dart';
import 'package:karya/views/overdue_list_view.dart';
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
        OverdueTaskListView(
          refreshData: () {
            setState(() {});
          },
        ),
        TaskListView(
          header: "Today",
          refreshData: () {
            setState(() {});
          },
          startDate: DateTime.now(),
          endDate: DateTime.now(),
        ),
        TaskListView(
          header: "Tomorrow",
          refreshData: () {
            setState(() {});
          },
          startDate: DateTime.now().add(const Duration(days: 1)),
          endDate: DateTime.now().add(const Duration(days: 1)),
        ),
        TaskListView(
          header: "Upcoming",
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

