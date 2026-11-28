import 'package:flutter/material.dart';

import 'models/log_entry.dart';
import 'services/log_service.dart';

//Экран журнала событий
class LogPage extends StatefulWidget{
  const LogPage({super.key});
  
  @override
  State<LogPage> createState() => _LogPageState();
}

class _LogPageState extends State<LogPage> {
  final LogService _logService = LogService();

  List<LogEntry> logs = [];
  bool isLoading = true;

  //Поле сортировки 
  int sortColumnIndex = 0;

  //Направление сортировки 
  bool sortAscending = false;


  @override
  void initState() {
    super.initState();
    loadLogs();
  }

  //Загружает записи журнала
  Future<void> loadLogs() async{
    final result = await _logService.getLogs();

    if (!mounted) return;

     setState(() {
      logs = result;
      isLoading = false;
    });
  }

  //Сортровка записи журнала
  void sortLogs(int columnIndex, bool ascending){
    setState(() {
      sortColumnIndex = columnIndex;
      sortAscending = ascending;

      logs.sort((a, b){
        int result;

        switch (columnIndex){
          case 0:
            result = a.date.compareTo(b.date);
            break;
          case 1:
            result = a.level.compareTo(b.level);
            break;
          case 2:
            result = a.category.compareTo(b.category);
            break;
          default:
            result = a.message.compareTo(b.message);
        }
        return ascending ? result : - result;
      
      });
    });
  }

  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        title: const Text('Журнал событий'),
      ),
      body: isLoading
        ? const Center(child:CircularProgressIndicator())
        : logs.isEmpty
          ? const Center(child: Text('Журнал пуст'))
          : SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: SingleChildScrollView(
                child: DataTable(
                  sortColumnIndex: sortColumnIndex,
                  sortAscending: sortAscending,
                  columns: [
                    DataColumn(
                      label: const Text('Дата и время'),
                      onSort: sortLogs,
                    ),
                    DataColumn(
                      label: const Text('Уровень'),
                      onSort: sortLogs,
                    ),
                    DataColumn(
                      label: const Text('Категория'),
                      onSort: sortLogs,
                    ),
                    DataColumn(
                      label: const Text('Сообщение'),
                      onSort: sortLogs,
                    ),
                  ], 
                  rows: logs.map((log) {
                    return DataRow(
                      cells: [
                        DataCell(Text(log.date.toString())),
                        DataCell(Text(log.level)),
                        DataCell(Text(log.category)),
                        DataCell(Text(log.message)),
                      ],
                    );
                  }).toList(),
                ),
              ),
          ),
    );
  }
}
