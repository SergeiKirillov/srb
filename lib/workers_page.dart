import 'package:flutter/material.dart';
import 'cl_worker.dart';
import 'worker_detail_page.dart';

class WorkersPage extends StatefulWidget{
  final int brigade;
  final List<Worker> workers;

  const WorkersPage({
    super.key,
    required this.brigade,
    required this.workers,
  });

  @override
  State<WorkersPage> createState() => _WorkersPageState();

  
}

class _WorkersPageState extends State<WorkersPage>{
  String searchText = '';
  String selectedShop = '';

  @override
  Widget build(BuildContext context) {

    final shops = widget.workers
      .where((worker)=>worker.brigade == widget.brigade)
      .map((worker)=>worker.shop.trim())
      .where((shop)=>shop.trim().isNotEmpty)
      .toSet()
      .toList()
    ..sort();

    final brigadeWorkers = widget.workers.where((worker) {
      
      final matchesBrigade = worker.brigade == widget.brigade;
      
      final matchesName = worker.name
        .toLowerCase()
        .contains(searchText.toLowerCase());
      
      final matchesShop = 
        selectedShop.isEmpty || worker.shop == selectedShop;

      return matchesBrigade &&  matchesName && matchesShop;
    }).toList();
      
    return Scaffold(
      appBar: AppBar(
        title: Text('Бригада № ${widget.brigade}'),
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
                  searchText = value;
                });
              },
            ),
          ),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: DropdownButtonFormField<String>(
              //initialValue:selectedShop != null && shops.contains(selectedShop)?selectedShop:null,
              initialValue:selectedShop,
              decoration: const InputDecoration(
                labelText:'Фильтр по цеху',
                border: OutlineInputBorder(),
              ),
              items: [
                const DropdownMenuItem<String>(
                  value: '',
                  child: Text('Все цеха'),
                ),
                ...shops.map(
                  (shop) => DropdownMenuItem<String>(
                    value: shop,
                    child: Text(shop),
                  ),
                ),
              ], 
              onChanged: (value) {
                setState(() {
                  selectedShop = value ?? '';
                });
              },
            ),
          ),

          const SizedBox(height: 8,),
        
          Expanded(
            child: ListView.builder(
              itemCount: brigadeWorkers.length,
              itemBuilder: (context, index){
                final worker = brigadeWorkers[index];

                return ListTile(
                  onTap: (){
                    Navigator.push(
                      context, 
                      MaterialPageRoute(
                        builder: (context)=>WorkerDetailPage(
                          worker: worker,
                        ),
                      ),
                    );
                  },
                  title: Text(worker.name),
                  subtitle: Text(worker.shop),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}