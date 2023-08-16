import 'package:dart_date/dart_date.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

import '../data/models/task.dart';
import '../data/services/Tasks.dart';

class AddTaskView extends StatefulWidget {
  const AddTaskView({super.key});

  @override
  State<AddTaskView> createState() => _AddTaskViewState();
}

class _AddTaskViewState extends State<AddTaskView> {
  Task task = Task(const Uuid().v4(), '', '', DateTime.now(), false, [], null);

  @override
  Widget build(BuildContext context) {
    final formKey = GlobalKey<FormState>();

    return Scaffold(
      appBar: AppBar(
        // TRY THIS: Try changing the color here to a specific color (to
        // Colors.amber, perhaps?) and trigger a hot reload to see the AppBar
        // change color while the other colors stay the same.
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: const Text("New Task"),
      ),
      body: TaskForm(
          formKey: formKey,
          task: task,
          onChangeName: onChangeName,
          onChangeDescription: onChangeDescription,
          onScheduleChange: onChangeSchedule),
      floatingActionButton: FloatingActionButton(
        tooltip: 'Increment',
        onPressed: () {
          if (formKey.currentState!.validate()) {
            print("Validated");
            Tasks().add(task);
          }
          Navigator.of(context).pop();
        },
        child: const Icon(Icons.save),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  void onChangeName(String? value) {
    setState(() {
      task.name = value ?? '';
    });
  }

  void onChangeDescription(String? value) {
    setState(() {
      task.description = value ?? '';
    });
  }

  void onChangeSchedule(DateTime value) {
    setState(() {
      task.schedule = value;
    });
  }
}

class TaskForm extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final Task task;
  final void Function(String? value) onChangeName;
  final void Function(String? value) onChangeDescription;
  final void Function(DateTime value) onScheduleChange;

  const TaskForm(
      {super.key,
      required this.formKey,
      required this.task,
      required this.onChangeName,
      required this.onChangeDescription,
      required this.onScheduleChange});

  void showDialog(BuildContext context, Widget child) {
    showCupertinoModalPopup<void>(
      context: context,
      builder: (BuildContext context) => Container(
        height: 216,
        padding: const EdgeInsets.only(top: 6.0),
        // The Bottom margin is provided to align the popup above the system
        // navigation bar.
        margin: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        // Provide a background color for the popup.
        color: CupertinoColors.systemBackground.resolveFrom(context),
        // Use a SafeArea widget to avoid system overlaps.
        child: SafeArea(
          top: false,
          child: child,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Form(
        key: formKey,
        child: Column(
          children: [
            TextFormField(
              decoration:
                  const InputDecoration(filled: true, labelText: "Name"),
              initialValue: task.name,
              onChanged: onChangeName,
            ),
            const SizedBox(height: 16),
            TextFormField(
              keyboardType: TextInputType.multiline,
              maxLines: 2,
              decoration:
                  const InputDecoration(filled: true, labelText: "Description"),
              initialValue: task.description,
              onChanged: onChangeDescription,
            ),
            const SizedBox(height: 16),
            TextFormField(
              readOnly: true,
              decoration:
                  const InputDecoration(filled: true, labelText: "Schedule"),
              initialValue: task.schedule.format("d/MMM/yyyy KK:mm a"),
              onTap: () {
                showDialog(
                    context,
                    CupertinoDatePicker(
                      showDayOfWeek: true,
                      initialDateTime: task.schedule,
                      onDateTimeChanged: onScheduleChange,
                    ));
              },
            )
          ],
        ),
      ),
    );
  }
}
