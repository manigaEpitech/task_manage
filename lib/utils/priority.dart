enum Priority {
  low,
  medium,
  high;

  String toShortString() => name;

  static Priority fromString(String priority) {
    return Priority.values.firstWhere(
      (e) => e.name == priority.toLowerCase(),
      orElse: () => Priority.medium,
    );
  }
}
