import 'package:flutter/material.dart';
import 'package:srb/worker_detail_page.dart';
import 'cl_worker.dart';
import 'worker_form_page.dart';

class AllWorkersPage extends StatefulWidget{
  final List<Worker> workers;
  final Future<void> Function(List<Worker>) onWorkersChanged;


  const AllWorkersPage({
    super.key,
    required this.workers,
    required this.onWorkersChanged,
  });

  @override 
  State<AllWorkersPage> createState()=> _AllWorkersPageState();
}

class _AllWorkersPageState extends State<AllWorkersPage> {
  String searchText = '';

  late List<Worker> currentWorkers;
  @override
  void initState(){
    super.initState();
    currentWorkers = List<Worker>.from(widget.workers);
  }



  @override
  Widget build(BuildContext context){
    final filteredWorkers = currentWorkers.where((worker) {
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
                    onTap: () async {
                      // Открытие формы 
                      final updatedWorker =await Navigator.push<Worker>(
                        context, 
                        MaterialPageRoute(
                          builder: (context)=>WorkerDetailPage(worker: worker),
                        ),
                      );
                      if(updatedWorker==null || !mounted) return;

                      final updatedWorkers = currentWorkers.map((item){
                        return item.id == updatedWorker.id ? updatedWorker:item;
                      }).toList();

                      await widget.onWorkersChanged(updatedWorkers);

                      if (!mounted) return;

                      setState(() {
                        currentWorkers=updatedWorkers;
                      });

                    },
                  );
                },
              ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: (){
          // Открытие формы добавления.
          Navigator.push(
            context, 
            MaterialPageRoute(
              builder: (context) => WorkerFormPage(
                onSave: (newWorker) async {},
              ),
            ),
          );
        },
        icon: const Icon(Icons.add),
        label: const Text('ADD'),
      ),
    );
  }
}
