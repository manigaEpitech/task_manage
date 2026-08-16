import 'dart:convert';
import 'dart:io';

import 'StackItem.dart';
import 'TaskStorage.dart';

class StackManage implements TaskStorage<StackItem> {
  Future<void> _createJsonFile(File file, List<StackItem> tasks) async {
    final jsonList = tasks.map((task) => task.toJson()).toList();
    final jsonFile = jsonEncode(jsonList);
    await file.writeAsString(jsonFile);
  }

  @override
  Future<bool> saveToFile(String filePath, StackItem items) async {
    try {
      final file = File(filePath);
      List<StackItem> currentTasks = [];

      if (await file.exists()) currentTasks = await readFromFile(filePath);

      currentTasks.add(items);
      await _createJsonFile(file, currentTasks);

      print("Your task is created !");
      return true;
    } catch (e) {
      print('Error ! $e');
      return false;
    }
  }

  @override
  Future<List<StackItem>> readFromFile(String filePath) async {
    try {
      final file = File(filePath);

      if (!await file.exists()) return [];

      final taskRestore = await file.readAsString();

      if (taskRestore.trim().isEmpty) return [];

      final List<dynamic> taskDecode = jsonDecode(taskRestore);

      return taskDecode.map((item) => StackItem.fromJson(item)).toList();
    } catch (e) {
      print('Error! $e');
      return [];
    }
  }

  @override
  Future<bool> updatedTask(String filePath, StackItem updatedItem) async {
    try {
      List<StackItem> currentTasks = await readFromFile(filePath);

      int index = currentTasks.indexWhere((task) => task.id == updatedItem.id);

      if (index != -1) {
        currentTasks[index] = updatedItem;

        final file = File(filePath);
        await _createJsonFile(file, currentTasks);

        return true;
      }

      print('there are not  Task with this ID!');
      return false;
    } catch (e) {
      print('ERROR ! $e');
      return false;
    }
  }

  @override
  Future<bool> deletedTask(String filePath, String idItem) async {
    try {
      List<StackItem> currentTasks = await readFromFile(filePath);

      int initLength = currentTasks.length;
      currentTasks.removeWhere((task) => task.id == idItem);

      if (currentTasks.length < initLength) {
        await _createJsonFile(File(filePath), currentTasks);
        print('Task deleted successfully !');
        return true;
      }

      print('there are not task to delete with this ID!');
      return false;
    } catch (e) {
      print('ERROR! $e');
      return false;
    }
  }

  @override
  Future<List<StackItem>> filterByPriorityOrDeadline(
    String filePath, {
    String? priority,
    String? deadLine,
  }) async {
    try {
      if (priority == null && deadLine == null) return [];

      List<StackItem> currentTasks = await readFromFile(filePath);

      final filteredResults = currentTasks.where((task) {
        final matchPriority =
            priority != null &&
            task.priority.toLowerCase() == priority.toLowerCase();
        final matchDeadline =
            deadLine != null &&
            task.deadLine != null &&
            task.deadLine!.toLowerCase().contains(deadLine.toLowerCase());

        return matchPriority || matchDeadline;
      }).toList();

      return filteredResults;
    } catch (e) {
      print('Error during filtering! $e');
      return [];
    }
  }
}
