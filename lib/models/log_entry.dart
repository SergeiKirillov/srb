class LogEntry {
  final int? id;
  final DateTime date;
  final String level;
  final String category;
  final String message;
  final String? details;

  const LogEntry({
    this.id,
    required this.date,
    required this.level,
    required this.category,
    required this.message,
    this.details,
  });

  //Преобразует объект в Мар lkz SQLite
  Map<String, dynamic> toMap(){
    return{
      'id':id,
      'date':date.toIso8601String(),
      'level': level,
      'category':category,
      'message':message,
      'details': details,
    };
  }

  // Создаёт объект из записи SQLite.
  factory LogEntry.fromMap(Map<String,dynamic> map) {
    return LogEntry(
      id: map['id'] as int?,
      date: DateTime.parse(map['date'] as String), 
      level: map['level'] as String, 
      category: map['category'] as String, 
      message:map['message'] as String,
      details: map['details'] as String?,
    );
  }

  



}