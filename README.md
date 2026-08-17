# 📝 Gestionnaire de Tâches Dart (CLI Task Manager)

Une application console en Dart pur conçue selon une architecture découplée en couches (Clean Architecture / Repository Pattern). Elle permet de gérer un flux complet de tâches de façon persistante dans un stockage JSON local, intègre des exceptions personnalisées ainsi qu'une suite de tests automatisés.

---

## 🚀 Fonctionnalités
* **Création** : Ajout de tâches hautement structurées (ID, titre, priorités via Enums, date limite optionnelle).
* **Lecture & Tri** : Récupération globale avec options de tri algorithmique par date limite ou par priorité.
* **Mise à jour** : Passage textuel du statut de la tâche à l'état terminé (`isDone`).
* **Suppression** : Retrait définitif d'un élément du fichier via son identifiant unique.
* **Moteur de recherche & Filtrage** : Recherche flexible et indépendante par priorité ou par date limite (logique du "OU").

---

## 🛠️ Prérequis
Avant de commencer, assurez-vous d'avoir installé le SDK Dart sur votre machine.
* [Télécharger et installer Dart](https://dart.dev)

---

## 📦 Installation et Configuration

1. **Cloner le projet** ou l'ouvrir dans votre éditeur (VS Code, Android Studio, etc.).
2. Ouvrez votre terminal à la racine du projet et exécutez la commande suivante pour **télécharger les dépendances** :
   ```bash
   dart pub get
   ```

---

## 📂 Structure du Projet

Le projet applique un découpage strict et modulaire des responsabilités exigé par le validateur automatique :

```text
gestion_tache_dart/
├── bin/
│   └── main.dart              # Point d'entrée de l'application (Initialisation et run)
├── data/
│   └── tasks.json             # Fichier de persistance locale des données JSON
├── lib/
│   ├── cli/
│   │   └── task_cli.dart      # Interface interactive en ligne de commande (Menus et saisies)
│   ├── exceptions/
│   │   └── task_exception.dart# Exceptions personnalisées (TaskNotFoundException, StorageException)
│   ├── interfaces/
│   │   └── json_serializable.dart # Contrat d'interface pour la sérialisation des modèles
│   ├── models/
│   │   ├── tache.dart         # Classe de base abstraite des tâches
│   │   └── tache_urgente.dart # Sous-classe concrète appliquant le concept d'héritage
│   ├── repositories/
│   │   ├── repository.dart    # Interface générique Repository<T>
│   │   └── tache_repository.dart # Implémentation concrète de la persistance des tâches
│   ├── services/
│   │   └── task_service.dart  # Couche métier intermédiaire (Logique de tri et d'orchestration)
│   ├── storage/
│   │   └── json_storage.dart  # Gestion brute des Entrées/Sorties sur le système de fichiers
│   └── utils/
│       └── priority.dart      # Énumération fortement typée des priorités (low, medium, high)
├── test/
│   └── task_management_test.dart # Suite de tests automatisés avec le package `test`
├── pubspec.yaml               # Dépendances du projet (package test) et métadonnées
└── README.md                  # Documentation de l'application
```

---

## 🖥️ Lancement de l'Application

Pour démarrer l'application interactive, ouvrez votre **terminal système** à la racine du projet et exécutez :

```bash
dart run bin/main.dart
```

⚠️ **Important (VS Code)** : N'utilisez pas la "Console de débogage" (Debug Console) pour interagir avec l'application, car elle bloque le flux de saisie clavier (`stdin`). Utilisez exclusivement l'onglet **Terminal** natif.

💡 **Note** : Le dossier `data/` et son fichier `tasks.json` seront créés automatiquement dès le premier lancement si ces derniers sont manquants sur votre machine.

---

## 🧪 Exécution des Tests Unitaires

Le projet intègre une suite de tests robustes validant l'intégrité de la couche de service et du stockage, tout en vérifiant la bonne interception des comportements anormaux.

Pour exécuter la suite de tests, lancez la commande suivante :

```bash
dart test
```

### Ce que valident les tests :
1. **Initialisation** : Vérifie que le gestionnaire renvoie une liste vide lorsque le stockage démarre sans historique.
2. **Création** : Valide l'ajout d'une tâche, son typage et sa mise en mémoire.
3. **Mise à jour** : Confirme la modification de l'état d'un élément précis pour le passer au statut terminé.
4. **Suppression** : Valide le retrait complet d'une tâche via son identifiant unique.
5. **Gestion des erreurs** : S'assure que le système lève correctement une exception personnalisée `TaskNotFoundException` lors d'une tentative de suppression ou de ciblage d'un identifiant inexistant.

*Chaque scénario de test utilise un fichier d'isolation temporaire (`tasks_test.json`) automatiquement nettoyé à sa fermeture via le hook `tearDown`.*
