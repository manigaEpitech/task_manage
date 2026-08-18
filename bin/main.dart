import 'package:cli_task_manager/storage/json_storage.dart';
import 'package:cli_task_manager/repositories/task_repository.dart';
import 'package:cli_task_manager/services/task_service.dart';
import 'package:cli_task_manager/cli/task_cli.dart';

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
