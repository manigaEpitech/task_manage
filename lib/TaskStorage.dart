import 'Task.dart';

abstract class TaskStorage<T extends Task> {
  Future<bool> saveToFile(String filePath, T item);
  Future<List<T>> readFromFile(String filePath);
  Future<bool> updateTask(String filePath, T updatedItem);
  Future<bool> deleteTask(String filePath, String idItem);
  Future<List<T>> filterBy(
    String filePath, {
    String? priority,
    String? deadLine,
  });
  Future<List<T>> getAllSorted(String filePath, String sortBy);
}
