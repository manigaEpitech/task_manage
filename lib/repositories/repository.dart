import '../models/task.dart';

abstract class Repository<T extends Task> {
  Future<List<T>> getAll();
  Future<void> add(T item);
  Future<void> update(T item);
  Future<void> delete(String id);
}
