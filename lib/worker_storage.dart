import 'dart:convert';
import 'dart:io';

import 'package:path_provider/path_provider.dart';

import 'cl_worker.dart';

class WorkerStorage {

  //определяет расположение рабочего workers.json.
  Future<File> _getFile() async {
    final directory = await getApplicationDocumentsDirectory();

    return File('${directory.path}/workers.json');    
  }

  //читает JSON и превращает записи в объекты Worker.
  Future<List<Worker>> loadWorkers() async {
    final file = await _getFile();
    
    if(!await file.exists()) {
      return[];
    }

    final jsonText = await file.readAsString();
    final List<dynamic> data = jsonDecode(jsonText);

    return data.map((item){
      return Worker.fromJson(
        Map<String, dynamic>.from(item as Map),
      );
    }).toList();

  }

  //преобразует работников обратно в JSON и записывает файл.  
  Future<void> saveWorkers(List<Worker> workers) async{
    final file = await _getFile();
    final data = workers.map((worker) => worker.toJson()).toList();
    final jsonText = const JsonEncoder.withIndent(' ').convert(data);
    await file.writeAsString(jsonText);
  }
}
