import 'dart:io';
import 'package:test/test.dart';

import '../lib/StackItem.dart';
import '../lib/StackManage.dart';

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

  // --- TEST 1 : Lire un fichier inexistant (readFromFile) ---
  test(
    '1. Doit retourner une liste vide si le fichier n\'existe pas',
    () async {
      final tasks = await manager.readFromFile(testFilePath);
      expect(tasks, isEmpty);
    },
  );

  // --- TEST 2 : Ajouter une tâche (saveToFile) ---
  test('2. Doit ajouter une tâche avec succès dans le fichier', () async {
    final tache = StackItem(id: '1', title: 'Test 1', priority: 'Haute');

    final result = await manager.saveToFile(testFilePath, tache);
    final tasks = await manager.readFromFile(testFilePath);

    expect(result, isTrue);
    expect(tasks.length, equals(1));
    expect(tasks.first.title, equals('Test 1'));
    expect(tasks.first.state, equals('To do'));
  });

  // --- TEST 3 : Ajouter plusieurs tâches à la suite ---
  test(
    '3. Doit ajouter une tâche à la suite de l\'existante sans l\'écraser',
    () async {
      final t1 = StackItem(id: '1', title: 'Tâche 1', priority: 'Basse');
      final t2 = StackItem(id: '2', title: 'Tâche 2', priority: 'Moyenne');

      await manager.saveToFile(testFilePath, t1);
      await manager.saveToFile(testFilePath, t2);

      final tasks = await manager.readFromFile(testFilePath);

      expect(tasks.length, equals(2));
      expect(tasks[0].id, equals('1'));
      expect(tasks[1].id, equals('2'));
    },
  );

  // --- TEST 4 : Modifier une tâche (updateTask) ---
  test(
    '4. Doit modifier correctement le statut d\'une tâche existante',
    () async {
      final t1 = StackItem(
        id: '1',
        title: 'Acheter pain',
        priority: 'Haute',
        state: 'To do',
      );
      await manager.saveToFile(testFilePath, t1);

      // Préparation de l'objet modifié
      final t1Modifiee = StackItem(
        id: '1',
        title: 'Acheter pain',
        priority: 'Haute',
        state: 'Done',
      );

      final updateResult = await manager.updatedTask(testFilePath, t1Modifiee);
      final tasks = await manager.readFromFile(testFilePath);

      expect(updateResult, isTrue);
      expect(
        tasks.first.state,
        equals('Done'),
      ); // Le statut est passé en texte brut 'Done'
    },
  );

  // --- TEST 5 : Supprimer une tâche (deleteTask) ---
  test('5. Doit supprimer une tâche spécifique via son ID', () async {
    final t1 = StackItem(
      id: '1',
      title: 'Tâche à supprimer',
      priority: 'Basse',
    );
    final t2 = StackItem(id: '2', title: 'Tâche à garder', priority: 'Haute');

    await manager.saveToFile(testFilePath, t1);
    await manager.saveToFile(testFilePath, t2);

    final deleteResult = await manager.deletedTask(testFilePath, '1');
    final tasks = await manager.readFromFile(testFilePath);

    expect(deleteResult, isTrue);
    expect(tasks.length, equals(1));
    expect(tasks.first.id, equals('2'));
  });
}
