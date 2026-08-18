import '../repositories/task_repository.dart';
import '../exceptions/task_exception.dart';
import '../models/task.dart';

class TaskService {
  final TaskRepository repository;

  TaskService(this.repository);

  Future<void> createTask(Task task) async {
    await repository.add(task);
  }

  Future<List<Task>> getTasks({String? sortBy}) async {
    final tasks = await repository.getAll();
    final tasksCopy = List<Task>.from(tasks);
    if (sortBy == 'priority') {
      tasksCopy.sort((a, b) => b.priority.index.compareTo(a.priority.index));
    } else if (sortBy == 'date') {
      tasksCopy.sort((a, b) {
        if (a.dueDate == null) return 1;
        if (b.dueDate == null) return -1;
        return a.dueDate!.compareTo(b.dueDate!);
      });
    }
    return tasksCopy;
  }

  Future<void> markAsDone(String id) async {
    try {
      final tasks = await repository.getAll();
      final index = tasks.indexWhere((t) => t.id == id);
      if (index == -1) throw TaskNotFoundException("ID $id introuvable.");
      final task = tasks[index];
      final updatedTask = task.copyWith(completed: true);
      await repository.update(updatedTask);
    } on TaskException {
      rethrow; // Propager l'exception pour qu'elle soit gérée ailleurs
    }
  }

  Future<void> deleteTask(String id) async {
    try {
      await repository.delete(id);
    } on TaskException {
      rethrow; // Propager l'exception pour qu'elle soit gérée ailleurs
    }
  }

  Future<List<Task>> searchTasks(String criterion) async {
    final tasks = await repository.getAll();
    final cleanCriterion = criterion.toLowerCase();
    return tasks.where((t) {
      return t.title.toLowerCase().contains(cleanCriterion) ||
          t.priority.name.toLowerCase() == cleanCriterion;
    }).toList();
  }
}
