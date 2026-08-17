import 'dart:io';
import 'package:test/test.dart';
import '../lib/storage/json_storage.dart';
import '../lib/repositories/task_repository.dart';
import '../lib/services/task_service.dart';
import '../lib/models/urgent_task.dart';
import '../lib/exceptions/task_exception.dart';

void main() {
  final testPath = 'data/tasks_test.json';
  late TaskService service;

  setUp(() {
    service = TaskService(TaskRepository(JsonStorage(testPath)));
  });

  tearDown(() async {
    final file = File(testPath);
    if (await file.exists()) await file.delete();
  });

  test('1. Liste vide par défaut', () async {
    expect(await service.getTasks(), isEmpty);
  });

  test('2. Créer une tâche', () async {
    await service.createTask(UrgentTask(id: '1', title: 'Test'));
    final list = await service.getTasks();
    expect(list.length, equals(1));
  });

  test('3. Marquer comme fait', () async {
    await service.createTask(UrgentTask(id: '1', title: 'Test'));
    await service.markAsDone('1');
    final list = await service.getTasks();
    expect(list.first.completed, isTrue);
  });

  test('4. Supprimer tâche', () async {
    await service.createTask(UrgentTask(id: '1', title: 'Test'));
    await service.deleteTask('1');
    expect(await service.getTasks(), isEmpty);
  });

  test(
    '5. Lever TaskNotFoundException en cas de mauvaise suppression',
    () async {
      expect(
        () => service.deleteTask('999'),
        throwsA(isA<TaskNotFoundException>()),
      );
    },
  );
}
