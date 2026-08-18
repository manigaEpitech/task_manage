import 'dart:io';
import '../exceptions/task_exception.dart';
import '../services/task_service.dart';
import '../utils/priority.dart';
import '../models/task.dart';
import '../models/normal_task.dart';
import '../models/urgent_task.dart';

class TaskCli {
  final TaskService service;
  TaskCli(this.service);

  Future<void> start() async {
    bool running = true;
    while (running) {
      _showMenu();
      final choice = stdin.readLineSync()?.trim();
      switch (choice) {
        case '1':
          await _addTask();
          break;
        case '2':
          await _listTasks();
          break;
        case '3':
          await _completeTask();
          break;
        case '4':
          await _deleteTask();
          break;
        case '5':
          await _searchTasks();
          break;
        case '6':
          running = false;
          print('\nAu revoir !');
          break;
        default:
          print('\nChoix invalide.');
      }
    }
  }

  void _showMenu() {
    print('\n====================================');
    print('       GESTIONNAIRE DE TÂCHES       ');
    print('====================================');
    print('1. Ajouter une tâche');
    print('2. Lister les tâches (Avec tris)');
    print('3. Terminer une tâche');
    print('4. Supprimer une tâche');
    print('5. Rechercher / Filtrer une tâche');
    print('6. Quitter');
    print('====================================');
    stdout.write('Votre choix : ');
  }

  // Dans la méthode _addTask:
  Future<void> _addTask() async {
    try {
      stdout.write('Titre: ');
      final title = stdin.readLineSync() ?? '';
      if (title.isEmpty) {
        stdout.writeln('❌ Le titre ne peut pas être vide!');
        return;
      }

      stdout.write('Type (normal/urgent): ');
      final typeInput = stdin.readLineSync()?.toLowerCase() ?? 'normal';
      if (!['normal', 'urgent'].contains(typeInput)) {
        stdout.writeln('❌ Type invalide! Utilisez "normal" ou "urgent".');
        return;
      }

      stdout.write('Priorité (low/medium/high) [medium]: ');
      final priorityInput = stdin.readLineSync()?.toLowerCase() ?? 'medium';
      Priority priority;
      try {
        priority = Priority.fromString(priorityInput);
      } catch (e) {
        stdout.writeln('❌ Priorité invalide! Utilisez low, medium ou high.');
        return;
      }

      stdout.write('Date (yyyy-MM-dd) [optionnel]: ');
      DateTime? dueDate;
      final dateInput = stdin.readLineSync();
      if (dateInput != null && dateInput.isNotEmpty) {
        try {
          dueDate = DateTime.parse(dateInput);
        } catch (e) {
          stdout.writeln('❌ Format de date invalide! Utilisez yyyy-MM-dd.');
          return;
        }
      }

      final id = DateTime.now().millisecondsSinceEpoch.toString();
      final task = typeInput == 'urgent'
          ? UrgentTask(
              id: id,
              title: title,
              priority: priority,
              dueDate: dueDate,
            )
          : NormalTask(
              id: id,
              title: title,
              priority: priority,
              dueDate: dueDate,
            );

      await service.createTask(task);
      stdout.writeln('✅ Tâche créée avec succès!');
    } catch (e) {
      stdout.writeln('❌ Erreur lors de la création: $e');
    }
  }

  Future<void> _listTasks() async {
    print('\n--- Options d\'affichage ---');
    print('1. Sans tri | 2. Par priorité | 3. Par date limite');
    stdout.write('Votre choix : ');
    final choice = stdin.readLineSync()?.trim();

    String? sortBy;
    if (choice == '2') sortBy = 'priority';
    if (choice == '3') sortBy = 'date';

    final tasks = await service.getTasks(sortBy: sortBy);
    _printTable(tasks);
  }

  Future<void> _completeTask() async {
    stdout.write('\nID de la tâche à terminer : ');
    final id = stdin.readLineSync()?.trim() ?? '';
    try {
      await service.markAsDone(id);
      print('Tâche marquée comme terminée.');
    } on TaskException catch (e) {
      print('Erreur CLI : $e');
    }
  }

  Future<void> _deleteTask() async {
    stdout.write('\nID de la tâche à supprimer : ');
    final id = stdin.readLineSync()?.trim() ?? '';
    try {
      await service.deleteTask(id);
      print('Tâche supprimée avec succès.');
    } on TaskException catch (e) {
      print('Erreur CLI : $e');
    }
  }

  Future<void> _searchTasks() async {
    stdout.write('\nEntrez un mot-clé (titre ou priorité) : ');
    final query = stdin.readLineSync()?.trim() ?? '';
    final results = await service.searchTasks(query);
    _printTable(results);
  }

  void _printTable(List<Task> tasks) {
    if (tasks.isEmpty) {
      print('Aucune tâche à afficher.');
      return;
    }
    print(
      '\nID   | Titre                      | Priorité | Échéance   | Statut',
    );
    print('----------------------------------------------------------------');
    for (final t in tasks) {
      print(
        '${t.id.padRight(4)} | ${t.title.padRight(26)} | ${t.priority.name.padRight(8)} | ${(t.dueDate ?? 'Aucune')} | ${t.completed ? "Fait" : "À faire"}',
      );
    }
  }

  Priority? _parsePriority(String input) {
    switch (input.toLowerCase().trim()) {
      case 'low':
        return Priority.low;
      case 'medium':
        return Priority.medium;
      case 'high':
        return Priority.high;
      default:
        return null;
    }
  }
}
