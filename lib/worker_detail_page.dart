import 'package:flutter/material.dart';
import 'cl_worker.dart';

class WorkerDetailPage extends StatelessWidget{
  final Worker worker;

  const WorkerDetailPage({
    super.key,
    required this.worker,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Карточка работника'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text(
            worker.name,
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: 20,),
          
          ListTile(
            leading: const Icon(Icons.cake),
            title: const Text('Дата рождения'),
            subtitle: Text(
              '${worker.birthday.day.toString().padLeft(2,'0')}.'
              '${worker.birthday.month.toString().padLeft(2,'0')}.'
              '${worker.birthday.year}',
            ),
          ),
          ListTile(
            leading: const Icon(Icons.work),
            title: const Text('Должность'),
            subtitle: Text(worker.position),
          ),

          ListTile(
            leading: const Icon(Icons.groups),
            title: const Text('Бригада'),
            subtitle: Text('${worker.brigade}'),
          ),

          ListTile(
            leading: Icon(
              worker.working ? Icons.check_circle: Icons.cancel,
              color: worker.working ? Colors.green:Colors.red,
            ),
            title: const Text('Статус'),
            subtitle: Text( 
              worker.working ? 'Работает':'Не работает',
            ),
          )
        ],
      ),
    );
  }
}