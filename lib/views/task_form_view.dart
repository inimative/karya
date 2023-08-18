import 'package:dart_date/dart_date.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:karya/data/models/task.dart';
import 'package:uuid/uuid.dart';

import '../data/services/Tasks.dart';

class TaskFormView extends StatefulWidget {
  final Task task;

  const TaskFormView({super.key, required this.task});

  @override
  State<TaskFormView> createState() => _TaskFormViewState(task: task);
}

class _TaskFormViewState extends State<TaskFormView> {
  final formKey = GlobalKey<FormState>();
  final dtController = TextEditingController();
  final subTaskController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
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

  _scrollToBottom() {
    _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
  }

  @override
  Widget build(BuildContext context) {
    var textTheme = Theme.of(context).textTheme;

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
        actions: [
          TextButton(
              onPressed: () {
                if (formKey.currentState!.validate()) {
                  Tasks().upsert(task);
                  Navigator.pop(context, task);
                }
              },
              child: const Text("Save"))
        ],
      ),
      body: SingleChildScrollView(
        controller: _scrollController,
        child: Padding(
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
                  decoration: const InputDecoration(
                      filled: true, labelText: "Schedule"),
                  onTap: () {
                    showDialog(
                        context,
                        CupertinoDatePicker(
                          showDayOfWeek: true,
                          initialDateTime: task.schedule,
                          onDateTimeChanged: (val) {
                            task.schedule = val;
                            dtController.text =
                                val.format("d/MMM/yyyy KK:mm a");
                          },
                        ));
                  },
                ),
                const SizedBox(height: 32),
                Text(
                  "Checklists",
                  style: textTheme.titleLarge,
                ),
                const Divider(thickness: 2),
                Column(
                  children: getSubTaskFields(),
                ),
                const SizedBox(height: 32),
                buildNewChecklistField(),
                const SizedBox(height: 64),
              ],
            ),
          ),
        ),
      ),
    );
  }

  TextFormField buildNewChecklistField() {
    return TextFormField(
      controller: subTaskController,
      decoration: InputDecoration(
        filled: true,
        labelText: "Add an item",
        suffixIcon: IconButton(
          icon: const Icon(Icons.add_outlined),
          onPressed: () {
            if (subTaskController.text.isEmpty) return;
            task.subTasks
                .add(SubTask(const Uuid().v4(), subTaskController.text, false));
            subTaskController.clear();
            setState(() => _scrollToBottom());
          },
        ),
      ),
    );
  }

  getSubTaskFields() {
    return task.subTasks
        .map((e) => Focus(
              onFocusChange: (focused) {
                if (!focused && e.name.isEmpty) {
                  task.subTasks = task.subTasks
                      .where((element) => element.id != e.id)
                      .toList();
                  setState(() {});
                }
              },
              child: TextFormField(
                key: Key(e.id),
                initialValue: e.name,
                decoration: InputDecoration(
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.cancel_outlined),
                    onPressed: () {
                      task.subTasks = task.subTasks
                          .where((element) => element.id != e.id)
                          .toList();
                      setState(() {});
                    },
                  ),
                ),
                onChanged: (String? value) {
                  e.name = value ?? '';
                },
              ),
            ))
        .toList();
  }
}
