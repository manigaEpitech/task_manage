import 'dart:io';
import 'package:test/test.dart';
import '../lib/storage/json_storage.dart';
import '../lib/repositories/task_repository.dart';
import '../lib/services/task_service.dart';
import '../lib/models/normal_task.dart';
import '../lib/models/urgent_task.dart';
import '../lib/models/task.dart';
import '../lib/exceptions/task_exception.dart';

void main() {
  final String testPath = 'data/tasks_test.json';
  late TaskService service;

  setUp(() {
    service = TaskService(TaskRepository(JsonStorage(testPath)));
  });

  tearDown(() async {
    final file = File(testPath);
    if (await file.exists()) await file.delete();
  });

  test('1. Liste vide par défaut', () async {
    final tasks = await service.getTasks();
    expect(tasks, isEmpty);
  });

  test('2. Enregistrement tâche normale', () async {
    final task = NormalTask(id: '101', title: 'Test');
    await service.createTask(task);
    final list = await service.getTasks();
    expect(list.length, equals(1));
  });

  test('3. Modification statut tâche', () async {
    final task = UrgentTask(id: '202', title: 'Urgent');
    await service.createTask(task);
    await service.markAsDone('202');
    final list = await service.getTasks();
    expect(list.first.completed, isTrue);
  });

  test('4. Suppression tâche', () async {
    final task = NormalTask(id: '303', title: 'Suppr');
    await service.createTask(task);
    await service.deleteTask('303');
    final list = await service.getTasks();
    expect(list, isEmpty);
  });

  test('5. Exception TaskNotFoundException', () async {
    expect(
      () => service.deleteTask('000'),
      throwsA(isA<TaskNotFoundException>()),
    );
  });
}
