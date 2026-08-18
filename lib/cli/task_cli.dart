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

  Future<void> _addTask() async {
    print('\n--- Ajouter une tâche ---');
    stdout.write('Titre : ');
    final title = stdin.readLineSync() ?? '';

    stdout.write('Priorité (low/medium/high) : ');
    final priorityInput = stdin.readLineSync() ?? '';
    final priority = _parsePriority(priorityInput) ?? Priority.medium;

    stdout.write('Date limite (YYYY-MM-DD, optionnelle) : ');
    final DateTime? dateInput = stdin.readLineSync()?.trim().isEmpty != true
        ? DateTime.parse(stdin.readLineSync()?.trim() ?? '')
        : null;
    final dueDate = dateInput;

    final id = DateTime.now().millisecondsSinceEpoch.toString();

    // Utilisation des classes concrètes d'héritage selon la priorité
    Task newTask;
    if (priority == Priority.high) {
      newTask = UrgentTask(id: id, title: title, dueDate: dueDate);
    } else {
      newTask = NormalTask(
        id: id,
        title: title,
        priority: priority,
        dueDate: dueDate,
      );
    }

    try {
      await service.createTask(newTask);
      print('\nTâche ajoutée avec succès ! ID: $id');
    } on TaskException catch (e) {
      print('\nErreur stockage : $e');
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
