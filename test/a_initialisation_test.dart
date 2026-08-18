import 'dart:io';
import 'package:test/test.dart';
import '../lib/storage/json_storage.dart';
import '../lib/repositories/task_repository.dart';
import '../lib/services/task_service.dart';

void main() {
  test(
    '1. Doit retourner une liste vide si aucun stockage n\'existe',
    () async {
      final service = TaskService(
        TaskRepository(JsonStorage('data/test_1.json')),
      );
      expect(await service.getTasks(), isEmpty);
      final file = File('data/test_1.json');
      if (await file.exists()) await file.delete();
    },
  );
}
