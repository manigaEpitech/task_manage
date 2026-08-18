import '../utils/priority.dart';
import 'task.dart';

class NormalTask extends Task {
  NormalTask({
    required super.id,
    required super.title,
    super.priority = Priority.medium,
    super.dueDate,
    super.completed,
  });

  @override
  NormalTask copyWith({bool? completed}) {
    return NormalTask(
      id: id,
      title: title,
      priority: priority,
      dueDate: dueDate,
      completed: completed ?? this.completed,
    );
  }

  @override
  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'type': 'normal',
    'priority': priority.name,
    'dueDate': dueDate?.toIso8601String(),
    'completed': completed,
  };

  factory NormalTask.fromJson(Map<String, dynamic> json) {
    return NormalTask(
      id: json['id'] as String,
      title: json['title'] as String,
      priority: Priority.fromString(json['priority'] as String? ?? 'medium'),
      dueDate: json['dueDate'] != null
          ? DateTime.parse(json['dueDate'] as String)
          : null,
      completed: json['completed'] as bool? ?? false,
    );
  }
}
