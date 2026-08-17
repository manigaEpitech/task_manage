import '../repositories/task_repository.dart';
import '../models/urgent_task.dart';

class TaskService {
  final TaskRepository repository;

  TaskService(this.repository);

  Future<void> createTask(UrgentTask task) async {
    await repository.add(task);
  }

  Future<List<UrgentTask>> getTasks({String? sortBy}) async {
    final tasks = await repository.getAll();
    if (sortBy == 'priority') {
      tasks.sort((a, b) => b.priority.index.compareTo(a.priority.index));
    } else if (sortBy == 'date') {
      tasks.sort((a, b) {
        if (a.dueDate == null) return 1;
        if (b.dueDate == null) return -1;
        return a.dueDate!.compareTo(b.dueDate!);
      });
    }
    return tasks;
  }

  Future<void> markAsDone(String id) async {
    final tasks = await repository.getAll();
    final task = tasks.firstWhere((t) => t.id == id);
    task.completed = true;
    await repository.update(task);
  }

  Future<void> deleteTask(String id) async {
    await repository.delete(id);
  }
}
