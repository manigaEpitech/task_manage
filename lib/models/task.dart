import '../interfaces/json_serializable.dart';
import '../utils/priority.dart';

abstract class Task implements JsonSerializable {
  final String id;

  final String title;

  final Priority priority;

  final DateTime? dueDate;

  final bool completed;

  Task({
    required this.id,
    required this.title,
    required this.priority,
    this.dueDate,
    this.completed = false,
  });

  Task copyWith({bool? completed});
  String get type;
  bool validate() {
    return id.isNotEmpty && title.isNotEmpty;
  }
}
