import 'dart:convert';
import 'dart:io';
import '../exceptions/task_exception.dart';

class JsonStorage {
  final String filePath;

  JsonStorage(this.filePath);

  Future<List<Map<String, dynamic>>> read() async {
    try {
      final file = File(filePath);

      if (!await file.exists()) {
        await file.create(recursive: true);
        await file.writeAsString(jsonEncode([]));
        return [];
      }

      final content = await file.readAsString();
      if (content.trim().isEmpty) return [];

      final List<dynamic> decoded = jsonDecode(content);
      return decoded.map((item) => item as Map<String, dynamic>).toList();
    } catch (e) {
      throw StorageException("Erreur lors de la lecture du fichier JSON : $e");
    }
  }

  Future<void> write(List<Map<String, dynamic>> data) async {
    try {
      final file = File(filePath);

      if (!await file.exists()) {
        await file.create(recursive: true);
      }
      await file.writeAsString(jsonEncode(data));
    } catch (e) {
      throw StorageException("Erreur lors de l'écriture du fichier JSON : $e");
    }
  }
}
