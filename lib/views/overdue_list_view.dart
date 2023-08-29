import 'package:flutter/material.dart';
import 'package:karya/data/models/task.dart';
import 'package:karya/data/services/Tasks.dart';
import 'package:karya/views/task_item_view.dart';

class OverdueTaskListView extends StatefulWidget {
  final void Function() refreshData;

  const OverdueTaskListView({
    super.key,
    required this.refreshData,
  });

  @override
  State<OverdueTaskListView> createState() => _OverdueTaskListViewState();
}

class _OverdueTaskListViewState extends State<OverdueTaskListView> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Task>>(
        future: TaskService.getOverdue(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            if (snapshot.data!.isNotEmpty) {
              return Column(
                children: snapshot.data!
                    .map((item) => TaskItemView(
                          item: item,
                          refreshData: widget.refreshData,
                        ))
                    .toList(),
              );
            }
            return Container(
              padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
              child: Text(
                "You are all caught up!",
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.titleLarge,
              ),
            );
          } else if (snapshot.hasError) {
            return Text('${snapshot.error}');
          } else {
            // By default, show a loading spinner.
            return const CircularProgressIndicator();
          }
        });
  }
}
