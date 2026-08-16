import 'dart:io';
import 'package:test/test.dart';

import '../lib/Task.dart';
import '../lib/StackManage.dart';
import '../lib/TaskExceptions.dart';

void main() {
  late StackManage manager;
  final String testFilePath = 'taches_test.json';

  setUp(() {
    manager = StackManage();
  });

  tearDown(() async {
    final file = File(testFilePath);
    if (await file.exists()) {
      await file.delete();
    }
  });

  test('1. Liste vide si pas de fichier', () async {
    final tasks = await manager.readFromFile(testFilePath);
    expect(tasks, isEmpty);
  });

  test('2. Sauvegarde et lecture d\'une tâche', () async {
    final tache = UrgentTask(id: '1', title: 'Test Tâche');
    await manager.saveToFile(testFilePath, tache);

    final tasks = await manager.readFromFile(testFilePath);
    expect(tasks.length, equals(1));
    expect(tasks.first.title, equals('Test Tâche'));
  });

  test('3. Tri des tâches par date', () async {
    final t1 = UrgentTask(id: '1', title: 'Loin', deadLine: '2026-12-31');
    final t2 = UrgentTask(id: '2', title: 'Proche', deadLine: '2026-01-01');

    await manager.saveToFile(testFilePath, t1);
    await manager.saveToFile(testFilePath, t2);

    final sorted = await manager.getAllSorted(testFilePath, 'date');
    expect(sorted.first.title, equals('Proche'));
  });

  test('4. Lever une exception TaskNotFoundException', () async {
    final fausseTache = UrgentTask(id: '999', title: 'Inconnue');
    expect(
      () => manager.updateTask(testFilePath, fausseTache),
      throwsA(isA<TaskNotFoundException>()),
    );
  });

  test('5. Suppression d\'une tâche', () async {
    final tache = UrgentTask(id: '10', title: 'À supprimer');
    await manager.saveToFile(testFilePath, tache);

    final deleteResult = await manager.deleteTask(testFilePath, '10');
    expect(deleteResult, isTrue);
  });
}
