import '../lib/storage/json_storage.dart';
import '../lib/repositories/task_repository.dart';
import '../lib/services/task_service.dart';
import '../lib/cli/task_cli.dart';

void main() {
  // 1. Initialisation synchrone des composants pour éviter le gel du flux
  final storage = JsonStorage('data/tasks.json');
  final repo = TaskRepository(storage);
  final service = TaskService(repo);
  final cli = TaskCli(service);

  print("Initialisation du système...");

  // 2. Lancement isolé de la CLI
  cli.start().catchError((error) {
    print("Une erreur critique est survenue : $error");
  });
}
