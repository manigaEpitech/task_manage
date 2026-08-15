# 📝 Gestionnaire de Tâches Dart (Stack Manager)

Une application console en Dart permettant de gérer une liste de tâches sauvegardée de façon persistante dans un fichier au format JSON. Le projet est structuré selon les principes de la programmation orientée objet (POO) avec une architecture basée sur des interfaces et propose des tests unitaires complets.

---

## 🚀 Fonctionnalités
* **Création** : Ajout de tâches à la suite dans un fichier JSON sans écraser l'existant.
* **Lecture** : Récupération et affichage de la liste complète des tâches.
* **Mise à jour** : Modification des informations ou du statut d'une tâche (`To do` / `Done`).
* **Suppression** : Retrait d'une tâche spécifique à partir de son identifiant unique.

---

## 🛠️ Prérequis
Avant de commencer, assurez-vous d'avoir installé le SDK Dart sur votre machine.
* [Télécharger et installer Dart](https://dart.dev)

---

## 📦 Installation et Configuration

1. **Cloner ou ouvrir le projet** dans votre éditeur de code préféré (VS Code, Android Studio, etc.).
2. Ouvrez votre terminal à la racine du projet et exécutez la commande suivante pour **télécharger les dépendances** (notamment le package de test) :
   ```bash
   dart pub get
   ```

---

## 🖥️ Lancement de l'Application

Pour exécuter le script principal (votre fichier contenant la fonction `main`), utilisez la commande `dart run` suivie du chemin vers votre fichier :

```bash
dart run bin/main.dart
```

💡 **Note** : Lors de l'exécution, un fichier `mes_taches.json` sera automatiquement créé à la racine du projet pour stocker vos données.

---

## 🧪 Exécution des Tests Unitaires

Le projet intègre une suite de 5 tests automatisés pour valider le bon fonctionnement du système de stockage (création, lecture, modification et suppression).

Pour lancer l'ensemble des tests, exécutez la commande suivante dans votre terminal :

```bash
dart test
```

### Ce que font les tests :
1. Vérifient que la lecture d'un fichier inexistant retourne bien une liste vide.
2. Valident l'ajout et l'encodage correct d'une tâche en JSON.
3. Vérifient que l'ajout successif de tâches ne corrompt pas la structure du fichier.
4. Valident la modification textuelle du statut d'une tâche.
5. Vérifient la suppression définitive d'un élément via son ID.

*Chaque test s'exécute sur un fichier temporaire isolé qui est automatiquement nettoyé après chaque passage.*

## 📂 Structure du Projet

Le projet respecte l'organisation standard d'une application Dart et se décompose comme suit :

```text
├── .dart_tool/             # Fichiers de configuration internes à Dart (générés automatiquement)
├── bin/                    # Points d'entrée de l'application
│   └── main.dart           # Fichier principal pour exécuter et tester le script
├── lib/                    # Cœur du code métier (Logique et Modèles)
│   ├── StackItem.dart      # Modèle de données de la tâche (Parsing JSON)
│   ├── TaskStorage.dart    # Interface abstraite générique du stockage
│   └── StackManage.dart    # Implémentation concrète de la gestion des fichiers
├── test/                   # Tests automatisés
│   └── stack_manage_test.dart # Suite des 5 tests unitaires pour StackManage
├── pubspec.yaml            # Dépendances (package test) et métadonnées du projet
└── README.md               # Documentation du projet
```

### Rôle des dossiers principaux :
*   **`lib/`** : Contient le code réutilisable. C'est ici que se trouve toute votre logique métier. Si vous décidez plus tard de passer sur une application mobile **Flutter**, vous pourrez réutiliser ce dossier tel quel.
*   **`bin/`** : Contient uniquement les scripts exécutables en ligne de commande.
*   **`test/`** : Regroupe tous les fichiers de tests. Dart impose que les fichiers à l'intérieur se terminent par le suffixe `_test.dart` pour être détectés par la commande `dart test`.
