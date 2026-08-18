import 'dart:io';
import 'package:test/test.dart';
import '../lib/storage/json_storage.dart';
import '../lib/repositories/task_repository.dart';
import '../lib/services/task_service.dart';
import '../lib/exceptions/task_exception.dart';

void main() {
  test(
    '5. Doit lancer une exception TaskNotFoundException si l\'ID n\'existe pas',
    () async {
      final service = TaskService(
        TaskRepository(JsonStorage('data/test_5.json')),
      );
      expect(
        () => service.deleteTask('invalid_id'),
        throwsA(isA<TaskNotFoundException>()),
      );
      final file = File('data/test_5.json');
      if (await file.exists()) await file.delete();
    },
  );
}
