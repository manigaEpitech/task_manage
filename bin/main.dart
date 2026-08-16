import '../lib/Task.dart';
import '../lib/StackManage.dart';

void main() async {
  final manager = StackManage();
  final String path = 'mes_taches.json';

  print("--- 1. CRÉATION ET SAUVEGARDE DE TÂCHES ---");
  final t1 = UrgentTask(
    id: "101",
    title: "Acheter le pain",
    deadLine: "2026-08-20",
  );
  final t2 = UrgentTask(
    id: "102",
    title: "Nettoyer le bureau",
    deadLine: "2026-08-18",
  );
  final t3 = UrgentTask(
    id: "103",
    title: "Réviser les cours Dart",
    deadLine: "2026-08-19",
  );

  await manager.saveToFile(path, t1);
  await manager.saveToFile(path, t2);
  await manager.saveToFile(path, t3);

  print("\n--- 2. AFFICHAGE TRIÉ PAR DATE (Exigence Sujet) ---");
  List<UrgentTask> tachesTriees = await manager.getAllSorted(path, "date");
  for (var task in tachesTriees) {
    String statut = (task.state == 'Done') ? 'Fait' : 'À faire';
    print(
      "[ID: ${task.id}] ${task.title} | Date: ${task.deadLine} | Statut: $statut",
    );
  }

  print("\n--- 3. MARQUER UNE TÂCHE COMME FAITE (Exigence Sujet) ---");
  final t2Modifiee = UrgentTask(
    id: "102",
    title: "Nettoyer le bureau",
    deadLine: "2026-08-18",
    state: 'Done',
  );
  await manager.updateTask(path, t2Modifiee);
  print("Tâche 102 marquée comme faite !");

  print("\n--- 4. SUPPRESSION D'UNE TÂCHE (Exigence Sujet) ---");
  await manager.deleteTask(path, "103");
  print("Tâche 103 supprimée !");
}
