abstract class Task {
  String id;
  String title;
  String priority;
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

class UrgentTask extends Task {
  UrgentTask({
    required super.id,
    required super.title,
    super.priority = 'high',
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
      priority: json['priority'] ?? 'high',
      deadLine: json['deadLine'] == 'None' ? null : json['deadLine'],
      state: json['state'] ?? 'To do',
    );
  }
}
