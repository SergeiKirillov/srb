import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/log_entry.dart';


//Хранилище журнала событий
class LogStorage {
  //Создаёт единый экземпляр хранилища
  static final LogStorage instance = LogStorage._internal();
  
  factory LogStorage() => instance;

  LogStorage._internal();

  Database? _database;

  //Открывает базу данных или создаёт её
  Future<Database>  get database async{
    if (_database != null) {
      return _database!;
    }

    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'srb_logs.db');

    _database = await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async{
        await db.execute('''
          CREATE TABLE log_entries (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            date TEXT NOT NULL,
            level TEXT NOT NULL,
            category TEXT NOT NULL,
            message TEXT NOT NULL,
            details TEXT
          )
        ''');
      },
    );
    return _database!;
  }

  //Сохраняет событие в базе данных.
  Future<int> insertLog(LogEntry entry) async {
    final db = await database;

    return await db.insert(
      'log_entries', 
      entry.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  //Загружает все события из базы данных.
  Future<List<LogEntry>> getLogs({
      String? level,
      String? category,
  }) async {
    
    final db = await database;

    final conditions = <String>[];
    final arguments = <Object?>[];

    if(level != null) {
      conditions.add('level=?');
      arguments.add(level);
    }

    if(category != null) {
      conditions.add('categoty=?');
      arguments.add(category);
    }

    final result = await db.query(
      'log_entries',
      where: conditions.isEmpty ? null : conditions.join(' AND '),
      whereArgs: arguments.isEmpty ? null : arguments,
      orderBy: 'date DESC',
    );

    return result.map((map)=>LogEntry.fromMap(map)).toList();
  }
}

