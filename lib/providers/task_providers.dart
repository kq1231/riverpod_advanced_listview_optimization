import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/task.dart';

// Simulates fetching tasks from an API
Future<List<Task>> fetchTasks() async {
  // Simulate network delay
  await Future.delayed(const Duration(seconds: 2));

  // Return mock data
  return List.generate(
    50,
    (index) =>
        Task(id: index, title: 'Task ${index + 1}', completed: index % 3 == 0),
  );
}

// AsyncNotifierProvider for managing tasks state
final tasksProvider = AsyncNotifierProvider<TasksNotifier, List<Task>>(
  () => TasksNotifier(),
);

// TasksNotifier class to manage tasks state
class TasksNotifier extends AsyncNotifier<List<Task>> {
  @override
  Future<List<Task>> build() async {
    // Initial load of tasks
    return await fetchTasks();
  }

  // Toggle task completion status
  Future<void> toggleTaskCompletion(Task newTask, int index) async {
    // Get current state
    final currentState = state;

    // Only proceed if we have data
    if (!currentState.hasValue) return;

    final tasks = currentState.value!;

    // Create a new list with the updated task (immutability)
    final updatedTasks = [...tasks];
    updatedTasks[index] = newTask;

    // Update state optimistically
    state = AsyncValue.data(updatedTasks);

    // Simulate API call to update on server
    // In a real app, you would make an API call here
    await Future.delayed(const Duration(milliseconds: 300));
  }

  // Refresh tasks
  Future<void> refresh() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() => fetchTasks());
  }
}

// Family provider for individual task by index
// This creates a separate provider for each index
final taskByIndexProvider = Provider.family<Task?, int>((ref, index) {
  final asyncTasks = ref.watch(tasksProvider);
  return asyncTasks.whenOrNull(
    data: (tasks) => index < tasks.length ? tasks[index] : null,
  );
});
