import 'package:flutter/material.dart';
import 'cl_worker.dart';

class WorkersPage extends StatelessWidget{
  final int brigade;
  final List<Worker> workers;

  const WorkersPage({
    super.key,
    required this.brigade,
    required this.workers,
  });

  @override
  Widget build(BuildContext context) {
    final brigadeWorkers = workers
      .where((worker)=>worker.brigade==brigade)
      .toList();

    return Scaffold(
      appBar: AppBar(
        title: Text('Бригада № $brigade'),
      ),
      body: ListView.builder(
        itemCount: brigadeWorkers.length,
        itemBuilder: (context, index){
          final worker = brigadeWorkers[index];

          return ListTile(
            title: Text(worker.name),
            subtitle: Text(worker.shop),
          );
        },
      ),
    );
  }
}