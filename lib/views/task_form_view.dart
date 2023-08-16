import 'package:dart_date/dart_date.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:karya/data/models/task.dart';
import 'package:karya/data/services/Tasks.dart';
import 'package:uuid/uuid.dart';

class TaskFormView extends StatefulWidget {
  final Task? task;
  const TaskFormView({super.key, this.task});

  @override
  State<TaskFormView> createState() => _TaskFormViewState();
}

class _TaskFormViewState extends State<TaskFormView> {
  final formKey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final descriptionController = TextEditingController();
  final dtController = TextEditingController();
  late DateTime pickedDt;

  @override
  void initState() {
    super.initState();
    pickedDt = widget.task?.schedule??DateTime.now();
    nameController.text = widget.task?.name??'';
    descriptionController.text = widget.task?.description??'';
    dtController.text =
        (widget.task?.schedule ?? DateTime.now()).format("d/MMM/yyyy KK:mm a");
  }

  @override
  void dispose() {
    super.dispose();

    nameController.dispose();
    descriptionController.dispose();
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
                controller: nameController,
                decoration:
                    const InputDecoration(filled: true, labelText: "Name"),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Name';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: descriptionController,
                decoration: const InputDecoration(
                    filled: true, labelText: "Description"),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Description';
                  }
                  return null;
                },
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
                        initialDateTime: pickedDt,
                        onDateTimeChanged: (val) {
                          pickedDt = val;
                          dtController.text =
                              pickedDt.format("d/MMM/yyyy KK:mm a");
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
            Task t = widget.task??Task(const Uuid().v4(), '',
                '', pickedDt, false, [], null);
            t.name = nameController.text;
            t.description = descriptionController.text;
            t.schedule = pickedDt;

            Tasks().upsert(t);
            Navigator.pop(context, t);
          }
        },
        child: const Icon(Icons.save),
      ),
    );
  }
}
