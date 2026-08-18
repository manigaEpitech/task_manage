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

  test('5. Marquer plusieurs tâches comme terminées', () async {
    final task1 = NormalTask(id: '301', title: 'Tâche 1');
    final task2 = NormalTask(id: '302', title: 'Tâche 2');

    await service.createTask(task1);
    await service.createTask(task2);

    await service.markAsDone('301');

    final list = await service.getTasks();
    expect(list.firstWhere((t) => t.id == '301').completed, isTrue);
    expect(list.firstWhere((t) => t.id == '302').completed, isFalse);
  });
}
