import 'task.dart';
import 'normal_task.dart';
import 'urgent_task.dart';
import '../utils/priority.dart';

class TaskFactory {
  static Task fromJson(Map<String, dynamic> json) {
    final type = json['type'] as String? ?? 'normal';

    if (type == 'urgent') {
      return UrgentTask.fromJson(json);
    }
    return NormalTask.fromJson(json);
  }

  /// Crée une tâche du type approprié
  static Task create({
    required String id,
    required String title,
    required String type,
    Priority priority = Priority.medium,
    DateTime? dueDate,
    bool completed = false,
  }) {
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
