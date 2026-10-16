import 'package:flutter/material.dart';

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
  //DateTime selectDate = DateTime(2026,1,1);
  DateTime selectDate = DateTime.now();

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

  @override
  Widget build(BuildContext context){
    final dateText = 
      '${selectDate.day.toString().padLeft(2,'0')}.'
      '${selectDate.month.toString().padLeft(2,'0')}.'
      '${selectDate.year}';
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Сменный справочник'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
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
                    Text(
                      dateText,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
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
            const SizedBox(height: 12,),
            const Card(
              child: ListTile(
                title: Text('Ночная смена'),
                subtitle: Text('Бригада № 4'),
                leading: Icon(Icons.nightlight_round),
              ),
            ),
            SizedBox(height: 20,),
            Card(
              child: ListTile(
                title: Text('Дневная смена'),
                subtitle: Text('Бригада № 4'),
                leading: Icon(Icons.wb_sunny),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

