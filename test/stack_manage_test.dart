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
    // 1. Création et enregistrement initial d'une tâche à faire
    final task = UrgentTask(id: '202', title: 'Urgent', completed: false);
    await service.createTask(task);

    // 2. Création de la version complétée (completed: true) via copyWith

    // 3. Appel direct au repository pour forcer la mise à jour sur le disque
    await service.markAsDone('202');

    // 4. Relecture immédiate depuis le fichier JSON pour vérification
    final list = await service.getTasks();
    final taskVerifiee = list.firstWhere((t) => t.id == '202');

    // Validation stricte du changement d'état
    expect(taskVerifiee.completed, isTrue);
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
