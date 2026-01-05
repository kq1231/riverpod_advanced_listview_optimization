import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/task_providers.dart';

class TodoItem extends ConsumerWidget {
  const TodoItem({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Get the index from the overridden provider
    final index = ref.watch(taskIndexProvider);

    // Watch only THIS specific task from the main tasks list using select
    // This ensures this widget only rebuilds when THIS task changes
    final task = ref.watch(
      tasksProvider.select((asyncValue) {
        return asyncValue.value?[index];
      }),
    );

    // If task is null (loading or error), return empty container
    if (task == null) {
      return const SizedBox.shrink();
    }

    // Print to demonstrate that only this item rebuilds
    debugPrint('Building TodoItem for index: $index');

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      elevation: 2,
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: task.completed ? Colors.green : Colors.orange,
          child: Text(
            '${index + 1}',
            style: const TextStyle(color: Colors.white),
          ),
        ),
        title: Text(
          task.title,
          style: TextStyle(
            decoration: task.completed ? TextDecoration.lineThrough : null,
            fontWeight: FontWeight.w500,
          ),
        ),
        subtitle: Text(
          task.completed ? 'Completed' : 'Pending',
          style: TextStyle(
            color: task.completed ? Colors.green : Colors.orange,
            fontSize: 12,
          ),
        ),
        trailing: Checkbox(
          value: task.completed,
          onChanged: (value) {
            // Toggle the task completion status in the main list
            ref
                .read(tasksProvider.notifier)
                .toggleTaskCompletion(task.copyWith(completed: value!), index);
          },
          activeColor: Colors.green,
        ),
        onTap: () {
          // Also allow tapping the entire tile to toggle
          ref
              .read(tasksProvider.notifier)
              .toggleTaskCompletion(
                task.copyWith(completed: !task.completed),
                index,
              );
        },
      ),
    );
  }
}
