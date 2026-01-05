import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/task_providers.dart';
import '../widgets/todo_item.dart';

class TasksScreen extends ConsumerWidget {
  const TasksScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Watch only the length of the list using select
    // This ensures the ListView only rebuilds when the list length changes
    final tasksLength = ref.watch(
      tasksProvider.select((value) => value.value?.length),
    );

    debugPrint('Building TasksScreen - List length: $tasksLength');

    return Scaffold(
      appBar: AppBar(
        title: const Text('Optimized ListView'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: ref
          .read(tasksProvider)
          .when(
            // Loading state
            loading: () => const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: 16),
                  Text('Loading tasks...'),
                ],
              ),
            ),
            // Error state
            error: (error, stack) => Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline, size: 48, color: Colors.red),
                  const SizedBox(height: 16),
                  Text('Error: $error'),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () => ref.invalidate(tasksProvider),
                    child: const Text('Retry'),
                  ),
                ],
              ),
            ),
            // Data state
            data: (tasks) {
              if (tasks.isEmpty) {
                return const Center(child: Text('No tasks available'));
              }

              return ListView.builder(
                itemCount: tasks.length,
                itemBuilder: (context, index) {
                  // Pass index directly as parameter
                  return TodoItem(index: index);
                },
              );
            },
          ),
    );
  }
}
