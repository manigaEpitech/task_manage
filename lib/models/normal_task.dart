import 'Task.dart';
import '../utils/priority.dart';

class NormalTask extends Task {
  NormalTask({
    required super.id,
    required super.title,
    super.priority = Priority.medium,
    super.dueDate,
    super.completed,
  });

  @override
  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'priority': priority.toString().split('.').last,
    'dueDate': dueDate?.toIso8601String(),
    'completed': completed,
  };

  factory NormalTask.fromJson(Map<String, dynamic> json) {
    return NormalTask(
      id: json['id'],
      title: json['title'],
      priority: Priority.values.firstWhere(
        (p) => p.toString().split('.').last == json['priority'],
        orElse: () => Priority.medium,
      ),
      dueDate: json['dueDate'] != null ? DateTime.parse(json['dueDate']) : null,
      completed: json['completed'] ?? false,
    );
  }
}
