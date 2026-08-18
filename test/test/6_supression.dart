import 'package:test/test.dart';
import '../../lib/storage/json_storage.dart';
import '../../lib/repositories/task_repository.dart';
import '../../lib/services/task_service.dart';
import '../../lib/models/normal_task.dart';

void main() {
  late TaskService service;

  setUp(() {
    service = TaskService(TaskRepository(JsonStorage('data/t3.json')));
  });

  test('6. Suppression d\'une tâche', () async {
    final task = NormalTask(id: '303', title: 'À Supprimer');
    await service.createTask(task);

    var list = await service.getTasks();
    expect(list.length, equals(1));

    await service.deleteTask('303');

    list = await service.getTasks();
    expect(list, isEmpty);
  });
}
