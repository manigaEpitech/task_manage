import 'dart:io';
import 'package:test/test.dart';
import '../lib/storage/json_storage.dart';
import '../lib/repositories/task_repository.dart';
import '../lib/services/task_service.dart';
import '../lib/models/urgent_task.dart';

void main() {
  test('3. Doit modifier le statut d\'une tâche à terminé', () async {
    final service = TaskService(
      TaskRepository(JsonStorage('data/test_3.json')),
    );
    await service.createTask(UrgentTask(id: '20', title: 'Rapport'));
    await service.markAsDone('20');
    final list = await service.getTasks();
    expect(list.first.completed, isTrue);
    final file = File('data/test_3.json');
    if (await file.exists()) await file.delete();
  });
}
