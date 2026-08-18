import 'dart:io';
import 'package:test/test.dart';
import '../lib/storage/json_storage.dart';
import '../lib/repositories/task_repository.dart';
import '../lib/services/task_service.dart';
import '../lib/models/normal_task.dart';

void main() {
  test('2. Doit enregistrer et relire une tâche normale', () async {
    final service = TaskService(
      TaskRepository(JsonStorage('data/test_2.json')),
    );
    await service.createTask(NormalTask(id: '10', title: 'Acheter lait'));
    final list = await service.getTasks();
    expect(list.length, equals(1));
    expect(list.first.title, equals('Acheter lait'));
    final file = File('data/test_2.json');
    if (await file.exists()) await file.delete();
  });
}
