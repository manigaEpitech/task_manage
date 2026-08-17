class TaskException implements Exception {
  final String message;

  TaskException(this.message);

  @override
  String toString() {
    return 'TaskException: $message';
  }
}

class TaskNotFoundException extends TaskException {
  TaskNotFoundException(String message) : super(message);

  @override
  String toString() {
    return 'TaskNotFoundException: $message';
  }
}

class StorageException extends TaskException {
  StorageException(String message) : super(message);

  @override
  String toString() {
    return 'StorageException: $message';
  }
}
