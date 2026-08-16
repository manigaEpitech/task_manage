class StackItem {
  String id;
  String title;
  String priority;
  String? deadLine;
  String state;

  StackItem({
    required this.id,
    required this.title,
    required this.priority,
    this.deadLine,
    this.state = 'To do',
  });

  Map<String, dynamic> toJson() => {
    'id': this.id,
    'title': this.title,
    'priority': this.priority,
    'deadline': this.deadLine ?? 'None',
    'state': this.state,
  };

  factory StackItem.fromJson(Map<String, dynamic> json) {
    return StackItem(
      id: json['id'],
      title: json['title'],
      priority: json['priority'],
      deadLine: json['deadline'] == 'none' ? null : json['deadLine'],
      state: json['state'] ?? 'To do',
    );
  }
}

abstract class Task {
  String id;
  String title;
  String priority; // 'low', 'medium', 'high'
  String? deadLine;
  String state;

  Task({
    required this.id,
    required this.title,
    required this.priority,
    this.deadLine,
    this.state = 'To do',
  });

  Map<String, dynamic> toJson();
}

class StandardTask extends Task {
  StandardTask({
    required super.id,
    required super.title,
    super.priority = 'medium',
    super.deadLine,
    super.state,
  });

  @override
  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'priority': priority,
    'deadLine': deadLine ?? 'None',
    'state': state,
  };
}

class UrgentTask extends Task {
  UrgentTask({
    required super.id,
    required super.title,
    super.priority = 'high', // Forcé à high par héritage
    super.deadLine,
    super.state,
  });

  @override
  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'priority': priority,
    'deadLine': deadLine ?? 'None',
    'state': state,
  };

  factory UrgentTask.fromJson(Map<String, dynamic> json) {
    return UrgentTask(
      id: json['id'],
      title: json['title'],
      priority: json['priority'],
      deadLine: json['deadLine'] == 'None' ? null : json['deadLine'],
      state: json['state'] ?? 'To do',
    );
  }
}
