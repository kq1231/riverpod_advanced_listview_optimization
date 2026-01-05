class Task {
  final int id;
  final String title;
  final bool completed;

  const Task({
    required this.id,
    required this.title,
    this.completed = false,
  });

  Task copyWith({
    int? id,
    String? title,
    bool? completed,
  }) {
    return Task(
      id: id ?? this.id,
      title: title ?? this.title,
      completed: completed ?? this.completed,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Task &&
        other.id == id &&
        other.title == title &&
        other.completed == completed;
  }

  @override
  int get hashCode => id.hashCode ^ title.hashCode ^ completed.hashCode;

  @override
  String toString() => 'Task(id: $id, title: $title, completed: $completed)';
}

