import '../interfaces/json_serializable.dart';
import '../utils/priority.dart';

abstract class Task implements JsonSerializable {
  final String id;

  String title;

  Priority priority;

  DateTime? dueDate;

  bool completed;

  Task({
    required this.id,
    required this.title,
    required this.priority,
    this.dueDate,
    this.completed = false,
  });

  void complete() {
    completed = true;
  }
}
