import 'package:test/test.dart';
import '../../lib/storage/json_storage.dart';
import '../../lib/repositories/task_repository.dart';
import '../../lib/services/task_service.dart';
import '../../lib/models/urgent_task.dart';

void main() {
  late TaskService service;

  setUp(() {
    service = TaskService(TaskRepository(JsonStorage('data/t3.json')));
  });

  test('3. Création et enregistrement tâche urgente', () async {
    final task = UrgentTask(id: '102', title: 'Test Urgent');
    await service.createTask(task);
    final list = await service.getTasks();

    expect(list.length, equals(1));
    expect(list[0].title, equals('Test Urgent'));
    expect(list[0], isA<UrgentTask>());
  });
}
