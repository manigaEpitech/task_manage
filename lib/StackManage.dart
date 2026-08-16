import 'dart:convert';
import 'dart:io';

import 'Task.dart';
import 'TaskStorage.dart';
import 'TaskExceptions.dart';

class StackManage implements TaskStorage<UrgentTask> {
  Future<void> _writeTrueJson(File file, List<UrgentTask> tasks) async {
    try {
      final jsonList = tasks.map((t) => t.toJson()).toList();
      await file.writeAsString(jsonEncode(jsonList));
    } catch (e) {
      throw StorageException("Impossible d'écrire dans le fichier JSON.");
    }
  }

  @override
  Future<bool> saveToFile(String filePath, UrgentTask item) async {
    final file = File(filePath);
    List<UrgentTask> currentTasks = await readFromFile(filePath);
    currentTasks.add(item);
    await _writeTrueJson(file, currentTasks);
    return true;
  }

  @override
  Future<List<UrgentTask>> readFromFile(String filePath) async {
    final file = File(filePath);
    if (!await file.exists()) return [];
    final content = await file.readAsString();
    if (content.trim().isEmpty) return [];

    final List<dynamic> decoded = jsonDecode(content);
    return decoded.map((item) => UrgentTask.fromJson(item)).toList();
  }

  @override
  Future<bool> updateTask(String filePath, UrgentTask updatedItem) async {
    List<UrgentTask> currentTasks = await readFromFile(filePath);
    int index = currentTasks.indexWhere((task) => task.id == updatedItem.id);

    if (index == -1) {
      throw TaskNotFoundException(
        "La tâche avec l'ID ${updatedItem.id} n'existe pas.",
      );
    }

    currentTasks[index] = updatedItem;
    await _writeTrueJson(File(filePath), currentTasks);
    return true;
  }

  @override
  Future<bool> deleteTask(String filePath, String idItem) async {
    List<UrgentTask> currentTasks = await readFromFile(filePath);
    int initLength = currentTasks.length;

    currentTasks.removeWhere((task) => task.id == idItem);

    if (currentTasks.length == initLength) {
      throw TaskNotFoundException(
        "Aucune tâche à supprimer avec l'ID $idItem.",
      );
    }

    await _writeTrueJson(File(filePath), currentTasks);
    return true;
  }

  @override
  Future<List<UrgentTask>> getAllSorted(String filePath, String sortBy) async {
    List<UrgentTask> tasks = await readFromFile(filePath);

    if (sortBy.toLowerCase() == 'priority') {
      Map<String, int> weight = {'high': 3, 'medium': 2, 'low': 1};
      tasks.sort(
        (a, b) => (weight[b.priority] ?? 0).compareTo(weight[a.priority] ?? 0),
      );
    } else if (sortBy.toLowerCase() == 'date') {
      tasks.sort((a, b) {
        if (a.deadLine == null) return 1;
        if (b.deadLine == null) return -1;
        return a.deadLine!.compareTo(b.deadLine!);
      });
    }
    return tasks;
  }

  @override
  Future<List<UrgentTask>> filterBy(
    String filePath, {
    String? priority,
    String? deadLine,
  }) async {
    if (priority == null && deadLine == null) return [];
    List<UrgentTask> currentTasks = await readFromFile(filePath);

    return currentTasks.where((task) {
      final matchPriority =
          priority != null &&
          task.priority.toLowerCase() == priority.toLowerCase();
      final matchDeadline =
          deadLine != null &&
          task.deadLine != null &&
          task.deadLine!.toLowerCase().contains(deadLine.toLowerCase());
      return matchPriority || matchDeadline;
    }).toList();
  }
}
