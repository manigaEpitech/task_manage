import 'task.dart';
import '../utils/priority.dart';

class UrgentTask extends Task {
  UrgentTask({
    required super.id,
    required super.title,
    super.priority = Priority.high,
    super.dueDate,
    super.completed,
  });

  @override
  UrgentTask copyWith({bool? completed}) {
    return UrgentTask(
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
    'type': 'urgent',
    'priority': priority.name,
    'dueDate': dueDate?.toIso8601String(),
    'completed': completed,
  };

  factory UrgentTask.fromJson(Map<String, dynamic> json) {
    return UrgentTask(
      id: json['id'] as String,
      title: json['title'] as String,
      priority: Priority.fromString(json['priority'] as String? ?? 'high'),
      dueDate: json['dueDate'] != null
          ? DateTime.parse(json['dueDate'] as String)
          : null,
      completed: json['completed'] as bool? ?? false,
    );
  }
}
