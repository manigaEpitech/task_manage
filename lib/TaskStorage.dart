abstract class TaskStorage<T> {
  Future<bool> saveToFile(String filePath, T items);
  Future<List<T?>> readFromFile(String filePath);
  Future<bool> updatedTask(String filePath, T updatedItem);
  Future<bool> deletedTask(String filePath, String idItem);
}
