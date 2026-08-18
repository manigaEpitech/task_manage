import 'dart:io';
import 'package:test/test.dart';
import '../lib/storage/json_storage.dart';
import '../lib/repositories/task_repository.dart';
import '../lib/services/task_service.dart';
import '../lib/models/normal_task.dart';

void main() {
  test(
    '4. Doit vider le fichier après suppression de l\'unique tâche',
    () async {
      final service = TaskService(
        TaskRepository(JsonStorage('data/test_4.json')),
      );
      await service.createTask(NormalTask(id: '30', title: 'Poubelles'));
      await service.deleteTask('30');
      expect(await service.getTasks(), isEmpty);
      final file = File('data/test_4.json');
      if (await file.exists()) await file.delete();
    },
  );
}
