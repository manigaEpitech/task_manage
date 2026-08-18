import 'dart:io';
import 'package:test/test.dart';
import '../lib/storage/json_storage.dart';
import '../lib/repositories/task_repository.dart';
import '../lib/services/task_service.dart';
import '../lib/models/normal_task.dart';

void main() {
  test('2. Doit enregistrer et relire une tâche', () async {
    final service = TaskService(TaskRepository(JsonStorage('data/t2.json')));
    await service.createTask(NormalTask(id: '10', title: 'Acheter du pain'));
    final list = await service.getTasks();
    expect(list.length, equals(1));
    final file = File('data/t2.json');
    if (await file.exists()) await file.delete();
  });
}
