import 'package:flutter/material.dart';
import 'cl_worker.dart';

class AllWorkersPage extends StatefulWidget{
  final List<Worker> workers;

  const AllWorkersPage({
    super.key,
    required this.workers,
  });

  @override 
  State<AllWorkersPage> createState()=> _AllWorkersPageState();
}

class _AllWorkersPageState extends State<AllWorkersPage> {
  String searchText = '';

  @override
  Widget build(BuildContext context){
    final filteredWorkers = widget.workers.where((worker) {
      return worker.name
          .toLowerCase()
          .contains(searchText.trim().toLowerCase());
    }).toList()
      ..sort(
        (a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()),
      );
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Все работники'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: TextField(
              decoration: const InputDecoration(
                labelText: 'Поиск по ФИО',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
              onChanged: (value){
                setState(() {
                  searchText=value;
                });
              },
            ),
          ),
          Expanded(
            child: filteredWorkers.isEmpty
              ?const Center(child: Text('Работники не найдены'),)
              :ListView.builder(
                itemCount: filteredWorkers.length,
                itemBuilder: (context, index){
                  final worker = filteredWorkers[index];

                  return ListTile(
                    title: Text(worker.name),
                    subtitle: Text(
                      'Цех: ${worker.shop} · Бригада: ${worker.brigade}',
                    ),
                    onTap: (){
                      // Открытие формы 6 добавим следующим этапом
                    },
                  );
                },
              ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: (){
          // Открытие формы добавления подключим позже.
        },
        icon: const Icon(Icons.add),
        label: const Text('ADD'),
      ),
    );
  }
}
