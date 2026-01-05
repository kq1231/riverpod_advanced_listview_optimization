import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/task_providers.dart';

class TodoItem extends ConsumerWidget {
  final int index;

  const TodoItem({
    super.key,
    required this.index,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Watch only THIS specific task from the main tasks list using select
    // This ensures this widget only rebuilds when THIS task changes
    final currentTask = ref.watch(
      tasksProvider.select((asyncValue) {
        return asyncValue.value?[index];
      }),
    );

    // Use the watched task
    final taskToDisplay = currentTask!;

    // Print to demonstrate when this item rebuilds
    debugPrint('Building TodoItem for index: $index');

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      elevation: 2,
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: taskToDisplay.completed ? Colors.green : Colors.orange,
          child: Text(
            '${index + 1}',
            style: const TextStyle(color: Colors.white),
          ),
        ),
        title: Text(
          taskToDisplay.title,
          style: TextStyle(
            decoration: taskToDisplay.completed ? TextDecoration.lineThrough : null,
            fontWeight: FontWeight.w500,
          ),
        ),
        subtitle: Text(
          taskToDisplay.completed ? 'Completed' : 'Pending',
          style: TextStyle(
            color: taskToDisplay.completed ? Colors.green : Colors.orange,
            fontSize: 12,
          ),
        ),
        trailing: Checkbox(
          value: taskToDisplay.completed,
          onChanged: (value) {
            // Toggle the task completion status in the main list
            ref
                .read(tasksProvider.notifier)
                .toggleTaskCompletion(taskToDisplay.copyWith(completed: value!), index);
          },
          activeColor: Colors.green,
        ),
        onTap: () {
          // Also allow tapping the entire tile to toggle
          ref
              .read(tasksProvider.notifier)
              .toggleTaskCompletion(
                taskToDisplay.copyWith(completed: !taskToDisplay.completed),
                index,
              );
        },
      ),
    );
  }
}
