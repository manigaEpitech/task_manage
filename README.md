# Gestionnaire de tâches (Projet Dart CLI)

Application en ligne de commande développée en **Dart pur**, permettant de gérer des tâches depuis un terminal.

Le projet a été réalisé dans le but de mettre en pratique les principaux concepts du langage Dart : programmation orientée objet, héritage, classes abstraites, interfaces, génériques, exceptions, programmation asynchrone, persistance JSON et tests unitaires.

---

## Fonctionnalités

L'application permet de :

* Ajouter une tâche
* Définir un titre
* Définir une priorité : `low`, `medium` ou `high`
* Ajouter une date limite optionnelle
* Lister les tâches
* Trier les tâches par priorité
* Trier les tâches par date limite
* Marquer une tâche comme terminée
* Supprimer une tâche
* Persister les données dans un fichier JSON local
* Gérer les erreurs avec des exceptions personnalisées

---

## Technologies utilisées

* **Dart**
* `dart:io` pour les interactions avec le terminal et les fichiers
* `dart:convert` pour la sérialisation JSON
* Package `test` pour les tests unitaires
* Git / GitHub pour le versionnement et la livraison

---

## Concepts Dart mis en pratique

Le projet utilise notamment :

* Classes et objets
* Classes abstraites
* Héritage
* Redéfinition de méthodes avec `@override`
* Interfaces
* Génériques
* Exceptions personnalisées
* Programmation asynchrone avec `Future`
* Collections et opérations sur les listes
* Sérialisation / désérialisation JSON
* Tests unitaires

---

## Architecture du projet

```text
gestion_tache_dart/
│
├── bin/
│   └── main.dart
│
├── lib/
│   ├── cli/
│   │   └── task_cli.dart
│   │
│   ├── exceptions/
│   │   └── task_exception.dart
│   │
│   ├── interfaces/
│   │   └── json_serializable.dart
│   │
│   ├── models/
│   │   ├── tache.dart
│   │   └── tache_urgente.dart
│   │
│   ├── repositories/
│   │   ├── repository.dart
│   │   └── tache_repository.dart
│   │
│   ├── services/
│   │   └── task_service.dart
│   │
│   ├── storage/
│   │   └── json_storage.dart
│   │
│   └── utils/
│       └── priority.dart
│
├── data/
│   └── tasks.json
│
├── test/
│   └── ...
│
├── .gitignore
├── analysis_options.yaml
├── CHANGELOG.md
├── pubspec.yaml
└── README.md
```

---

## Prérequis

Pour exécuter le projet, il faut disposer du SDK Dart.

Vérifier l'installation :

```bash
dart --version
```

---

## Installation

Cloner le dépôt :

```bash
git clone https://github.com/mtoumamt63-hue/Gestion_Tache_Dart.git
```

Se placer dans le projet :

```bash
cd Gestion_Tache_Dart
```

Installer les dépendances :

```bash
dart pub get
```

---

## Lancer l'application

Exécuter :

```bash
dart run bin/main.dart
```

L'application affiche ensuite un menu permettant de gérer les tâches :

```text
====================================
       GESTIONNAIRE DE TÂCHES
====================================
1. Ajouter une tâche
2. Lister les tâches
3. Terminer une tâche
4. Supprimer une tâche
5. Rechercher / Filtrer une tâche
6. Quitter
====================================
Votre choix :
```

---

## Exécuter les tests

Lancer l'ensemble des tests :

```bash
dart test
```

Le projet contient plusieurs tests couvrant notamment :

* l'ajout d'une tâche ;
* la validation des données ;
* l'héritage ;
* la complétion ;
* la suppression ;
* le tri par priorité ;
* le tri par date.

---

## Analyser le code

Pour vérifier la qualité et détecter les problèmes statiques :

```bash
dart analyze
```

Le projet doit retourner :

```text
No issues found!
```

---

## Persistance des données

Les tâches sont sauvegardées localement dans :

```text
data/tasks.json
```

Le stockage utilise le format JSON.

Exemple :

```json
[
  {
    "id": "1",
    "title": "Apprendre Dart",
    "priority": "high",
    "completed": false,
    "dueDate": "2026-08-10"
  }
]
```

Les données restent disponibles après la fermeture puis le redémarrage de l'application.

---

## Architecture logicielle

Le projet suit une séparation des responsabilités :

### Models

Les modèles représentent les données métier.

```text
Task
UrgentTask
```

### Repository

Le repository fournit une abstraction pour manipuler les données.

```text
Repository<T>
TaskRepository
```

L'utilisation de `T` permet d'avoir un repository générique.

### Service

`TaskService` contient la logique métier de l'application.

### Storage

`JsonStorage` s'occupe de la lecture et de l'écriture des données dans le fichier JSON.

### CLI

`TaskCli` gère les interactions avec l'utilisateur depuis le terminal.

### Exceptions

Les erreurs métier sont représentées par des exceptions personnalisées.

---

## Validation du projet

Avant livraison, les commandes suivantes doivent fonctionner :

```bash
dart analyze
dart test
dart run bin/main.dart
```

---

## Auteur

MANIGA TOKPA ABOU (L'ambasssadeur)