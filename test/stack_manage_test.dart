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

  group('Tests de gestion des tâches', () {
    test('1. Liste vide par défaut', () async {
      final tasks = await service.getTasks();
      expect(tasks, isEmpty);
    });

    test('2. Création et enregistrement tâche normale', () async {
      final task = NormalTask(id: '101', title: 'Test Normal');
      await service.createTask(task);
      final list = await service.getTasks();

      expect(list.length, equals(1));
      expect(list[0].title, equals('Test Normal'));
      expect(list[0].completed, isFalse);
    });

    test('3. Création et enregistrement tâche urgente', () async {
      final task = UrgentTask(id: '102', title: 'Test Urgent');
      await service.createTask(task);
      final list = await service.getTasks();

      expect(list.length, equals(1));
      expect(list[0].title, equals('Test Urgent'));
      expect(list[0], isA<UrgentTask>());
    });

    test('4. Marquer une tâche comme terminée', () async {
      final task = UrgentTask(id: '202', title: 'Urgent', completed: false);
      await service.createTask(task);

      // Vérifier que la tâche est bien créée avec completed: false
      var list = await service.getTasks();
      expect(list[0].completed, isFalse);

      // Marquer comme terminée
      await service.markAsDone('202');

      // Vérifier que le changement est persisté
      list = await service.getTasks();
      final taskVerifiee = list.firstWhere((t) => t.id == '202');
      expect(taskVerifiee.completed, isTrue);
    });

    test('5. Marquer plusieurs tâches comme terminées', () async {
      final task1 = NormalTask(id: '301', title: 'Tâche 1');
      final task2 = NormalTask(id: '302', title: 'Tâche 2');

      await service.createTask(task1);
      await service.createTask(task2);

      await service.markAsDone('301');

      final list = await service.getTasks();
      expect(list.firstWhere((t) => t.id == '301').completed, isTrue);
      expect(list.firstWhere((t) => t.id == '302').completed, isFalse);
    });

    test('6. Suppression d\'une tâche', () async {
      final task = NormalTask(id: '303', title: 'À Supprimer');
      await service.createTask(task);

      var list = await service.getTasks();
      expect(list.length, equals(1));

      await service.deleteTask('303');

      list = await service.getTasks();
      expect(list, isEmpty);
    });

    test('7. Exception TaskNotFoundException lors de la suppression', () async {
      expect(
        () => service.deleteTask('000'),
        throwsA(isA<TaskNotFoundException>()),
      );
    });

    test('8. Exception TaskNotFoundException lors de la complétion', () async {
      expect(
        () => service.markAsDone('999'),
        throwsA(isA<TaskNotFoundException>()),
      );
    });

    test('9. Persistance des données après création', () async {
      final task = UrgentTask(
        id: '401',
        title: 'Tâche Persistée',
        completed: false,
      );
      await service.createTask(task);

      // Créer un nouveau service avec le même storage
      final newService = TaskService(TaskRepository(JsonStorage(testPath)));
      final list = await newService.getTasks();

      expect(list.length, equals(1));
      expect(list[0].id, equals('401'));
      expect(list[0].title, equals('Tâche Persistée'));
    });

    test('10. Recherche de tâches par critère', () async {
      await service.createTask(
        NormalTask(id: '501', title: 'Faire les courses'),
      );
      await service.createTask(NormalTask(id: '502', title: 'Appeler maman'));

      final results = await service.searchTasks('faire');
      expect(results.length, equals(1));
      expect(results[0].title, equals('Faire les courses'));
    });

    test('11. Tri des tâches par priorité', () async {
      await service.createTask(NormalTask(id: '601', title: 'Normal'));
      await service.createTask(UrgentTask(id: '602', title: 'Urgent'));

      final sorted = await service.getTasks(sortBy: 'priority');
      expect(sorted[0], isA<UrgentTask>()); // High priority first
    });

    test('12. Gestion des tâches avec dates', () async {
      final dueDate = DateTime(2026, 12, 31);
      final task = NormalTask(id: '701', title: 'Avec Date', dueDate: dueDate);

      await service.createTask(task);
      final list = await service.getTasks();

      expect(list[0].dueDate, equals(dueDate));
    });
  });
}
