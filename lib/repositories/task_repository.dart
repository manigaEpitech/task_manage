import 'repository.dart';
import '../models/factory_task.dart';
import '../models/task.dart';
import '../storage/json_storage.dart';
import '../exceptions/task_exception.dart';

class TaskRepository implements Repository<Task> {
  final JsonStorage storage;

  TaskRepository(this.storage);

  @override
  Future<List<Task>> getAll() async {
    final rawData = await storage.read();
    return rawData.map<Task>((json) {
      return TaskFactory.fromJson(json);
    }).toList();
  }

  @override
  Future<void> add(Task item) async {
    final list = await getAll();
    list.add(item);
    await storage.write(list.map((t) => t.toJson()).toList());
  }

  @override
  Future<void> update(Task item) async {
    final list = await getAll(); // ✅ Désérialiser complètement
    final index = list.indexWhere((t) => t.id == item.id);
    if (index == -1) throw TaskNotFoundException("Tâche introuvable.");

    list[index] = item; // ✅ Remplacer l'objet complet
    await storage.write(list.map((t) => t.toJson()).toList());
  }

  @override
  Future<void> delete(String id) async {
    final list = await getAll();
    final initLength = list.length;
    list.removeWhere((t) => t.id == id);
    if (list.length == initLength) {
      throw TaskNotFoundException("Tâche introuvable.");
    }
    await storage.write(list.map((t) => t.toJson()).toList());
  }
}
