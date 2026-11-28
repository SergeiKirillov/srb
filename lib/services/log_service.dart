import '../models/log_entry.dart';
import 'log_storage.dart';

class LogService {
  final LogStorage _storage = LogStorage();

  //Регистрирует новые событие
  Future<int> log({
    required String level,
    required String category, 
    required String message, 
    String? details,
  }) async {
    final entry =LogEntry(
      date: DateTime.now(), 
      level: level, 
      category: category, 
      message: message, 
      details: details,
    );
    return await _storage.insertLog(entry);
  }

  Future<List<LogEntry>> getLogs({
    String? level,
    String? category,
  }) async {
    return await _storage.getLogs(
      level: level,
      category: category,
    );
  }
}