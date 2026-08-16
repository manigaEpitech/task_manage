import '../lib/StackItem.dart';
import '../lib/StackManage.dart';

void main() async {
  final manager = StackManage();
  final String path = 'mes_taches.json';

  print("--- 1. AJOUT DE 5 TÂCHES INITIALES ---");

  final tache1 = StackItem(
    id: "101",
    title: "Acheter le pain",
    priority: "Haute",
    deadLine: "Ce soir",
  );
  final tache2 = StackItem(
    id: "102",
    title: "Nettoyer le bureau",
    priority: "Moyenne",
  );
  final tache3 = StackItem(
    id: "103",
    title: "Réviser les cours Dart",
    priority: "Haute",
    deadLine: "Demain",
  );
  final tache4 = StackItem(
    id: "104",
    title: "Payer la facture d'électricité",
    priority: "Haute",
  );
  final tache5 = StackItem(
    id: "105",
    title: "Aller à la salle de sport",
    priority: "Basse",
  );

  // Ajouts successifs à la suite les unes des autres
  await manager.saveToFile(path, tache1);
  await manager.saveToFile(path, tache2);
  await manager.saveToFile(path, tache3);
  await manager.saveToFile(path, tache4);
  await manager.saveToFile(path, tache5);

  print("\n--- 2. LECTURE ET AFFICHAGE DES 5 TÂCHES ENREGISTRÉES ---");
  List<StackItem> toutesLesTaches = await manager.readFromFile(path);
  for (var task in toutesLesTaches) {
    String affichageStatut = (task.state == 'Done') ? 'Fait' : 'À faire';
    print(
      "[ID: ${task.id}] ${task.title} | Priorité: ${task.priority} | Statut: $affichageStatut",
    );
  }

  print("\n--- 3. MODIFICATION DE LA TÂCHE 101 ET 103 ---");
  final tache1Modifiee = StackItem(
    id: "101",
    title: "Acheter le pain",
    priority: "Haute",
    deadLine: "Ce soir",
    state: 'Done',
  );

  final tache3Modifiee = StackItem(
    id: "103",
    title: "Réviser les cours Dart",
    priority: "Maximale", // Changement de priorité
    deadLine: "Ce week-end",
    state: 'To do',
  );

  await manager.updatedTask(path, tache1Modifiee);
  await manager.updatedTask(path, tache3Modifiee);

  print("\n--- 4. SUPPRESSION DE LA TÂCHE 105 ---");
  await manager.deletedTask(path, "105");

  print("\n--- 5. VÉRIFICATION FINALE DU FICHIER JSON ---");
  List<StackItem> listeFinale = await manager.readFromFile(path);
  for (var task in listeFinale) {
    String affichageStatut = (task.state == 'Done') ? 'Fait' : 'À faire';
    print(
      "[ID: ${task.id}] ${task.title} | Priorité: ${task.priority} | Statut: $affichageStatut",
    );
  }

  print("\n--- 6. TEST DE RECHERCHE / FILTRAGE PAR PRIORITÉ SEULE ---");
  print("-> Recherche des tâches avec la priorité 'Haute' :");
  List<StackItem> resultatPriorite = await manager.filterByPriorityOrDeadline(
    path,
    priority: "Haute",
  );

  if (resultatPriorite.isEmpty) {
    print("Aucune tâche trouvée avec cette priorité.");
  } else {
    for (var task in resultatPriorite) {
      print("   [ID: ${task.id}] ${task.title} (Priorité: ${task.priority})");
    }
  }

  print("\n--- 7. TEST DE RECHERCHE / FILTRAGE PAR DEADLINE SEULE ---");
  print(
    "-> Recherche des tâches prévues pour 'Ce week-end' (insensible à la casse) :",
  );
  List<StackItem> resultatDeadline = await manager.filterByPriorityOrDeadline(
    path,
    deadLine: "ce week-end",
  );

  if (resultatDeadline.isEmpty) {
    print("Aucune tâche trouvée pour cette date.");
  } else {
    for (var task in resultatDeadline) {
      print("   [ID: ${task.id}] ${task.title} (Deadline: ${task.deadLine})");
    }
  }

  print("\n--- 8. TEST DE RECHERCHE COMBINÉE (LOGIQUE DU 'OU') ---");
  print(
    "-> Recherche des tâches avec priorité 'Moyenne' OU prévues 'Ce soir' :",
  );
  List<StackItem> resultatCombines = await manager.filterByPriorityOrDeadline(
    path,
    priority: "Moyenne",
    deadLine: "Ce soir",
  );

  if (resultatCombines.isEmpty) {
    print("Aucune tâche ne correspond à ces critères.");
  } else {
    for (var task in resultatCombines) {
      print(
        "   [ID: ${task.id}] ${task.title} | Priorité: ${task.priority} | Deadline: ${task.deadLine ?? 'Aucune'}",
      );
    }
  }
}
