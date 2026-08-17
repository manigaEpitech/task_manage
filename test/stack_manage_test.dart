import 'dart:io';
import 'package:test/test.dart';
import '../lib/storage/json_storage.dart';
import '../lib/repositories/task_repository.dart';
import '../lib/services/task_service.dart';
import '../lib/models/urgent_task.dart';
import '../lib/exceptions/task_exception.dart';

void main() {
  // Un chemin de fichier unique par test pour éviter les conflits sur le serveur
  final String path1 = 'data/tasks_test_1.json';
  final String path2 = 'data/tasks_test_2.json';
  final String path3 = 'data/tasks_test_3.json';
  final String path4 = 'data/tasks_test_4.json';
  final String path5 = 'data/tasks_test_5.json';

  // Nettoyage global après TOUS les tests
  tearDownAll(() async {
    for (var p in [path1, path2, path3, path4, path5]) {
      final file = File(p);
      if (await file.exists()) await file.delete();
    }
  });

  test('1. Liste vide par défaut', () async {
    final service = TaskService(TaskRepository(JsonStorage(path1)));
    expect(await service.getTasks(), isEmpty);
  });

  test('2. Créer une tâche', () async {
    final service = TaskService(TaskRepository(JsonStorage(path2)));
    // Utilisation d'un ID fixe "201" au lieu d'un timestamp variable
    await service.createTask(UrgentTask(id: '201', title: 'Test unitaire'));
    final list = await service.getTasks();
    expect(list.length, equals(1));
    expect(list.first.title, equals('Test unitaire'));
  });

  test('3. Marquer comme fait', () async {
    final service = TaskService(TaskRepository(JsonStorage(path3)));
    await service.createTask(UrgentTask(id: '301', title: 'A faire'));
    await service.markAsDone('301');
    final list = await service.getTasks();
    expect(list.first.completed, isTrue);
  });

  test('4. Supprimer tâche', () async {
    final service = TaskService(TaskRepository(JsonStorage(path4)));
    await service.createTask(UrgentTask(id: '401', title: 'A supprimer'));
    await service.deleteTask('401');
    expect(await service.getTasks(), isEmpty);
  });

  test(
    '5. Lever TaskNotFoundException en cas de mauvaise suppression',
    () async {
      final service = TaskService(TaskRepository(JsonStorage(path5)));
      expect(
        () => service.deleteTask('999'),
        throwsA(isA<TaskNotFoundException>()),
      );
    },
  );
}
