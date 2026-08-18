import 'task.dart';
import 'normal_task.dart';
import 'urgent_task.dart';
import '../utils/priority.dart';

class TaskFactory {
  static Task fromJson(Map<String, dynamic> json) {
    final type = json['type'] as String? ?? 'normal';
    final id = json['id'] as String;
    final title = json['title'] as String;
    final priority = Priority.fromString(
      json['priority'] as String? ?? 'medium',
    );
    final dueDate = json['dueDate'] != null
        ? DateTime.parse(json['dueDate'] as String)
        : null;
    final completed = json['completed'] as bool? ?? false;

    if (type == 'urgent') {
      return UrgentTask(
        id: id,
        title: title,
        priority: priority,
        dueDate: dueDate,
        completed: completed,
      );
    }
    return NormalTask(
      id: id,
      title: title,
      priority: priority,
      dueDate: dueDate,
      completed: completed,
    );
  }
}
