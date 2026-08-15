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
