import 'Task.dart';
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
  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'priority': priority.toShortString(),
    'dueDate': dueDate?.toIso8601String(),
    'completed': completed,
  };

  factory UrgentTask.fromJson(Map<String, dynamic> json) {
    return UrgentTask(
      id: json['id'],
      title: json['title'],
      priority: Priority.values.firstWhere(
        (p) => p.toString().split('.').last == json['priority'],
        orElse: () => Priority.high,
      ),
      dueDate: json['dueDate'] != null ? DateTime.parse(json['dueDate']) : null,
      completed: json['completed'] ?? false,
    );
  }
}
