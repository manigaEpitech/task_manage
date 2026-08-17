import 'dart:io';

import '../exceptions/task_exception.dart';
import '../services/task_service.dart';
import '../utils/priority.dart';
import '../models/urgent_task.dart';

class TaskCli {
  final TaskService service;

  TaskCli(this.service);

  Future<void> start() async {
    bool running = true;

    while (running) {
      _showMenu();

      final choice = stdin.readLineSync();

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
          running = false;
          print('\nAu revoir !');
          break;

        default:
          print('\nChoix invalide.');
      }
    }
  }

  void _showMenu() {
    print('');
    print('====================================');
    print('       GESTIONNAIRE DE TÂCHES       ');
    print('====================================');
    print('1. Ajouter une tâche');
    print('2. Lister les tâches');
    print('3. Terminer une tâche');
    print('4. Supprimer une tâche');
    print('5. Quitter');
    print('====================================');
    stdout.write('Votre choix : ');
  }

  Future<void> _addTask() async {
    print('\n--- Ajouter une tâche ---');

    stdout.write('Titre : ');
    final title = stdin.readLineSync() ?? '';

    stdout.write('Priorité (low/medium/high) : ');
    final priorityInput = stdin.readLineSync() ?? '';

    final priority = _parsePriority(priorityInput);

    if (priority == null) {
      print('Priorité invalide.');
      return;
    }

    stdout.write('Date limite (YYYY-MM-DD, optionnelle) : ');
    final dateInput = stdin.readLineSync() ?? '';

    DateTime? deadLineString;
    if (dateInput.trim().isNotEmpty) {
      final parsedDate = DateTime.tryParse(dateInput);
      if (parsedDate == null) {
        print('Format de date invalide (Attendu: YYYY-MM-DD).');
        return;
      }
      deadLineString = parsedDate;
    }

    try {
      final id = DateTime.now().millisecondsSinceEpoch.toString();

      final task = UrgentTask(
        id: id,
        title: title,
        priority: priority,
        dueDate: deadLineString,
      );

      await service.createTask(task);

      print('\nTâche ajoutée avec succès !');
      print('ID : ${task.id}');
      print('Titre : ${task.title}');
    } on TaskException catch (e) {
      print('\nErreur : $e');
    }
  }

  Future<void> _listTasks() async {
    print('\n--- Liste des tâches ---');

    print('1. Sans tri');
    print('2. Trier par priorité');
    print('3. Trier par date limite');

    stdout.write('Votre choix : ');
    final choice = stdin.readLineSync();

    try {
      List<UrgentTask> tasks;

      switch (choice) {
        case '1':
          tasks = await service.getTasks();
          break;

        case '2':
          tasks = await service.getTasks(sortBy: 'priority');
          break;

        case '3':
          tasks = await service.getTasks(sortBy: 'date');
          break;

        default:
          print('Choix invalide.');
          return;
      }

      if (tasks.isEmpty) {
        print('Aucune tâche.');
        return;
      }

      print('');

      for (final task in tasks) {
        final displayDeadline = task.dueDate ?? 'Aucune date';

        print(
          '${task.id} | '
          '${task.title} | '
          '${task.priority.name.toUpperCase()} | '
          '$displayDeadline | '
          '${task.completed ? "Terminée" : "En cours"}',
        );
      }
    } on TaskException catch (e) {
      print('Erreur : $e');
    }
  }

  Future<void> _completeTask() async {
    print('\n--- Terminer une tâche ---');

    stdout.write('ID de la tâche : ');
    final id = stdin.readLineSync() ?? '';

    try {
      await service.markAsDone(id);
      print('Tâche terminée avec succès.');
    } on TaskException catch (e) {
      print('Erreur : $e');
    }
  }

  Future<void> _deleteTask() async {
    print('\n--- Supprimer une tâche ---');

    stdout.write('ID de la tâche : ');
    final id = stdin.readLineSync() ?? '';

    try {
      await service.deleteTask(id);
      print('Tâche supprimée avec succès.');
    } on TaskException catch (e) {
      print('Erreur : $e');
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
