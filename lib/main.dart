import 'package:flutter/material.dart';
import 'cl_worker.dart';
import 'worker_storage.dart';

import 'dart:convert';
import 'dart:io';
import 'package:file_picker/file_picker.dart';

import 'workers_page.dart';
import 'all_workers_page.dart';


void main() {
  runApp(const SRBApp());
}

class SRBApp extends StatelessWidget {
  const SRBApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Сменный справочник',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: .fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});
  
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>{
  DateTime selectDate = DateTime.now();

  final WorkerStorage storage = WorkerStorage();
  List<Worker> workers = [];
  bool isLoadingWorkers = true;
  String? workersError;

  Future<void> importWorkers() async {
    try {
      final selectedFile = await FilePicker.pickFile(
        type: FileType.custom,
        allowedExtensions: ['json'],
      );

      if (selectedFile == null) return;

      
      final jsonText = await File(selectedFile.path!).readAsString();
      
      final List<dynamic> data = jsonDecode(jsonText);

      final importedWorkers = data.map((item){
        return Worker.fromJson(
          Map<String,dynamic>.from(item as Map),
        );
      }).toList();

      await storage.saveWorkers(importedWorkers);

      if (!mounted) return;

      setState(() {
        workers=importedWorkers;
        workersError=null;
        isLoadingWorkers=false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Работники успешно импортированы'),
        ),
      );
    } catch (e) {
      if(!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Ошибка импорта: $e'),
        ),
      );
    }
  }


  Future<void> exportWorkers() async {
    try {
      final jsonText = jsonEncode(
        workers.map((worker)=>worker.toJson()).toList(),
      );
      
      final result =await FilePicker.saveFile(
        dialogTitle:'Экспорт работников',
        fileName: 'workers.json',
        type: FileType.custom,
        allowedExtensions: ['json'],
        bytes:utf8.encode(jsonText),
      );
      if (!mounted) return;

      if(result==null){
        result;
      }

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Экспорт работника выполнен'),
        ),
      );
    } catch (e) {
      if(!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Ошибка Экспорта: $e'),
        ),
      );
    }
  }




  Future<void> loadWorkers() async {
    try {
      final loadedWorkers = await storage.loadWorkers();
      
      if(!mounted) return;

      setState(() {
        workers = loadedWorkers;
        workersError = null;
        isLoadingWorkers = false;
      });

      //debugPrint('Загружено работников: ${workers.length}');

    } catch (e) {
      if(!mounted) return;

      setState(() {
        workersError = 'НЕ УДАЛОСЬ ЗАГРУЗИТЬ РАБОТНИКОВ: $e';
        isLoadingWorkers=true;
      });
      
    }
  } 

  int countWorkersInBrigade(int brigade){
    return workers
      .where((worker)=>worker.brigade==brigade)
      .length;
  }

  bool isBrigade5Working(DateTime date, int grafic7){
    switch(grafic7){
      case 1:
        //Выходные: Воскресенье и понедельник.
        return date.weekday >= DateTime.tuesday && date.weekday <=DateTime.saturday;
      case 2:
        //Выходные: Пятница и суббота        
        return (date.weekday >= DateTime.monday && date.weekday <= DateTime.thursday)||(date.weekday == DateTime.sunday);
      default:
        return date.weekday >=DateTime.monday && date.weekday <= DateTime.friday;
    }
  }

  final Set<String> holidays = {
    '2026-01-01',
    '2026-01-02',
    '2026-10-25',
    '2026-12-31',
  };

  
  bool isHoliday(DateTime date){
    final key = 
      '${date.year}-'
      '${date.month.toString().padLeft(2,'0')}-'
      '${date.day.toString().padLeft(2,'0')}';
    return holidays.contains(key);
  }


  int getNightBrigade(DateTime date){
    final statDate = DateTime(2026,1,1);
    final days = DateTime(
      date.year,
      date.month,
      date.day,
    ).difference(statDate).inDays;
    const brigades = [2,1,4,3];

    return brigades[days % 4];
  }

  int getDayBrigade(DateTime date){
    final nightBrigade = getNightBrigade(date);
    return switch(nightBrigade){
      2=>4,
      1=>3,
      4=>2,
      3=>1,
      _=>0,
    };

  }

  void goToToday(){
    setState(() {
      selectDate=DateTime.now();
    });
  }

  void previousDay(){
    setState(() {
      selectDate = selectDate.subtract(
        const Duration(days: 1),
      );
    });
  }
  
  void nextDay(){
    setState(() {
      selectDate = selectDate.add(
        const Duration(days: 1),
      );
    });
  }

  Future<void> selectedDate() async {
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: selectDate, 
      firstDate: DateTime(2000,1,1), 
      lastDate: DateTime(2035,04,24),
      helpText: 'Выберите дату смены',
      cancelText: 'Отмена',
      confirmText: 'Выбрать',
    );
    if (pickedDate!=null) {
      setState(() {
        selectDate=pickedDate;
      });
    }

  }


  @override
  void initState() {
    super.initState();
    loadWorkers();
  }
  

  @override
  Widget build(BuildContext context){
       
    final weekdays = [
      'Понедельник',
      'Вторник',
      'Среда',
      'Четверг',
      'Пятница',
      'Суббота',
      'Воскресенье',
    ];
    final weekdayText = weekdays[selectDate.weekday-1];

     
    final dateText = 
      '$weekdayText, '
      '${selectDate.day.toString().padLeft(2,'0')}.'
      '${selectDate.month.toString().padLeft(2,'0')}.'
      '${selectDate.year}';

    return Scaffold(
      appBar: AppBar(
        title: const Text('Сменный справочник'),
        actions: [
          PopupMenuButton<String>(
            icon: const Icon(Icons.more_vert),
            onSelected: (value) {
              switch (value) {
                case 'workers':
                  Navigator.push(
                    context, 
                    MaterialPageRoute(
                      builder: (context)=>AllWorkersPage(
                        workers: workers,
                      ),
                    ),
                  );
                  break;
                case 'import':
                  //Здесь импорт работников.
                  importWorkers();
                  break;
                case 'export':
                  //Здесь экспорт работников.
                  exportWorkers();
                  break;
                case 'about':
                  //Информация о программе 
                  break;
              }
            },
            itemBuilder: (context)=>[
              const PopupMenuItem(
                value: 'workers',
                child: ListTile(
                  leading: Icon(Icons.people),
                  title: Text('Просмотр работников'),
                ),
              ),
              const PopupMenuItem(
                value: 'import',
                child: ListTile(
                  leading: Icon(Icons.file_open),
                  title: Text('Импорт работников'),
                ),
              ),
              const PopupMenuItem(
                value:'export',
                child: ListTile(
                  leading: Icon(Icons.save_alt),
                  title: Text('Эксорт работников'),
                ),
              ),
              const PopupMenuItem(
                value: 'about',
                child: ListTile(
                  leading: Icon(Icons.info_outline),
                  title: Text('О программе'),   
                ),
              ),
            ]
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            
            // ElevatedButton.icon(
            //   onPressed: importWorkers,
            //   icon: const Icon(Icons.upload_file), 
            //   label: const Text('Импорт сотрудников'),
            // ),

            const Text('Расписание смен', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),),
            const SizedBox(height: 16,),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      onPressed: previousDay,
                      icon: const Icon(Icons.chevron_left),
                    ),
                    TextButton(
                      onPressed: selectedDate,
                      child: Text(
                        dateText,
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: isHoliday(selectDate)
                            ?Colors.red
                            :selectDate.weekday >= 6?Colors.green:Colors.black,
                        ),
                      ),
                    ),
                    IconButton(
                      onPressed: nextDay, 
                      icon: const Icon(Icons.chevron_right),
                    ),
                  ],
                ),
              ),
            ),
            if(isHoliday(selectDate))
              const Padding(
                padding: EdgeInsets.only(top: 4),
                child: Text(
                  'Праздничный день',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.red,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            Align(
              alignment: Alignment.centerRight,
              child: TextButton.icon(
                onPressed: goToToday, 
                icon: const Icon(Icons.today),
                label: const Text('Сегодня')
              ),
            ),
            const SizedBox(height: 12,),
            Card(
              child: ListTile(
                onTap: (){
                  Navigator.push(
                    context, 
                    MaterialPageRoute(
                      builder: (context) => WorkersPage(
                        brigade: getNightBrigade(selectDate),
                        workers: workers,
                      ),
                    ),
                  );
                },
                title: const Text('Ночная смена'),
                subtitle: Text(
                  'Бригада № ${getNightBrigade(selectDate)}'
                  ' - ${countWorkersInBrigade(getNightBrigade(selectDate))} работников',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                leading: const Icon(
                  Icons.nightlight_round,
                  color: Colors.blue,
                  size:30,
                ),
              ),
            ),
            SizedBox(height: 20,),
            Card(
              child: ListTile(
                onTap: (){
                  Navigator.push(
                    context, 
                    MaterialPageRoute(
                      builder: (context) => WorkersPage(
                        brigade: getDayBrigade(selectDate), 
                        workers: workers,
                      ),
                    ),
                  );
                },  
                title: const Text('Дневная смена'),
                subtitle: Text(
                  'Бригада № ${getDayBrigade(selectDate)}'
                  ' - ${countWorkersInBrigade(getDayBrigade(selectDate))} работников',
                   style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                leading: const Icon(
                  Icons.wb_sunny,
                  color: Colors.amber,
                  size:30,
                ),
              ),
            ),
            SizedBox(height: 20,),
            Card(
              child: ListTile(
                onTap: (){
                  final workingWorkers = workers.where((worker){
                    return worker.brigade==5 && worker.working && isBrigade5Working(selectDate, worker.grafic7);
                  }).toList();

                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => WorkersPage(
                        brigade: 5, 
                        workers: workingWorkers,
                      ),
                    ),
                  );
                },
                title: const Text('5-я Бригада'),
                subtitle: Text(
                  'Работает: '
                  '${workers.where((worker)=>(worker.brigade==5 && worker.working && isBrigade5Working(selectDate, worker.grafic7))).length} '
                  'из ${countWorkersInBrigade(5)} работников', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold,)
                ),
                leading: const Icon(
                  Icons.group,
                  color: Colors.green,
                  size:30,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

