import 'package:dart_date/dart_date.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:karya/data/models/task.dart';
import 'package:karya/data/services/Tasks.dart';

class TaskFormView extends StatefulWidget {
  final Task task;

  const TaskFormView({super.key, required this.task});

  @override
  State<TaskFormView> createState() => _TaskFormViewState(task: task);
}

class _TaskFormViewState extends State<TaskFormView> {
  final formKey = GlobalKey<FormState>();
  final dtController = TextEditingController();
  Task task;

  _TaskFormViewState({required this.task});

  @override
  void initState() {
    super.initState();
    dtController.text = task.schedule.format("d/MMM/yyyy KK:mm a");
  }

  @override
  void dispose() {
    super.dispose();

    dtController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    void showDialog(BuildContext context, Widget child) {
      showCupertinoModalPopup<void>(
        context: context,
        builder: (BuildContext context) => Container(
          height: 216,
          padding: const EdgeInsets.only(top: 6.0),
          margin: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          color: CupertinoColors.systemBackground.resolveFrom(context),
          child: SafeArea(
            top: false,
            child: child,
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text("New Task"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                initialValue: task.name,
                decoration:
                    const InputDecoration(filled: true, labelText: "Name"),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Name';
                  }
                  return null;
                },
                onChanged: (String? value) => task.name = value ?? '',
              ),
              const SizedBox(height: 16),
              TextFormField(
                initialValue: task.description,
                decoration: const InputDecoration(
                    filled: true, labelText: "Description"),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Description';
                  }
                  return null;
                },
                onChanged: (String? value) => task.description = value ?? '',
              ),
              const SizedBox(height: 16),
              TextFormField(
                readOnly: true,
                controller: dtController,
                decoration:
                    const InputDecoration(filled: true, labelText: "Schedule"),
                onTap: () {
                  showDialog(
                      context,
                      CupertinoDatePicker(
                        showDayOfWeek: true,
                        initialDateTime: task.schedule,
                        onDateTimeChanged: (val) {
                          task.schedule = val;
                          dtController.text = val.format("d/MMM/yyyy KK:mm a");
                        },
                      ));
                },
              )
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          if (formKey.currentState!.validate()) {
            Tasks().upsert(task);
            Navigator.pop(context, task);
          }
        },
        child: const Icon(Icons.save),
      ),
    );
  }
}
