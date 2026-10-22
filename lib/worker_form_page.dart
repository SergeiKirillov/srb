import 'package:flutter/material.dart';
import 'cl_worker.dart';

class WorkerFormPage extends StatefulWidget{
  final Worker? worker;
  final Future<void> Function(Worker) onSave;
  
  const WorkerFormPage({
    super.key,
    this.worker,
    required this.onSave,
  });

  @override
  State<WorkerFormPage> createState()=>_WorkerFormPageState();

}

class _WorkerFormPageState extends State<WorkerFormPage>{
  final _formKey =GlobalKey<FormState>();
  final _nameController =TextEditingController();
  final _shopController = TextEditingController();
  final _positionController = TextEditingController();

  @override
  void initState() {
    super.initState();

    final worker = widget.worker;

    if (worker != null) {
      _nameController.text = worker.name;
      _shopController.text = worker.shop;
      _positionController.text = worker.position;

    }
  }

  @override
  void dispose(){
    _nameController.dispose();
    _shopController.dispose();
    _positionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.worker == null
          ?'Новый работник'
          :'Редактирование работника',
        ),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            TextFormField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: 'ФИО',
                border: OutlineInputBorder(),
              ),
              validator: (value){
                if (value == null || value.trim().isEmpty) {
                  return 'Введите ФИО';
                }
                return null;
              },
            ),
            const SizedBox(height: 16,),
            TextFormField(
              controller: _shopController,
              decoration: const InputDecoration(
                labelText: 'Цех',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _positionController,
              decoration: const InputDecoration(
                labelText: 'Должность',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 24,),
            FilledButton.icon(
              onPressed: () async {
                if(_formKey.currentState!.validate()){
                  // Сохранение.
                  final oldWorker = widget.worker;

                  if(oldWorker==null){
                    if(!mounted) return; 

                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Добавление нового работника подключим далее'),),);
                    return;
                  }

                  final updatedWorker = Worker(
                    id: oldWorker.id, 
                    name: _nameController.text.trim(), 
                    birthday: oldWorker.birthday, 
                    shop: _shopController.text.trim(), 
                    position: _positionController.text.trim(), 
                    brigade: oldWorker.brigade, 
                    grafic7: oldWorker.grafic7,
                    working: oldWorker.working, 
                    phoneMobileWork: oldWorker.phoneMobileWork, 
                    phoneMobilePersonal1: oldWorker.phoneMobilePersonal1, 
                    phoneMobilePersonal2: oldWorker.phoneMobilePersonal2, 
                    phoneWork1: oldWorker.phoneWork1, 
                    phoneWork2: oldWorker.phoneWork2, 
                    phoneWork3: oldWorker.phoneWork3, 
                    phoneShop: oldWorker.phoneShop,
                  );
                  
                  final navigator = Navigator.of(context);

                  await widget.onSave(updatedWorker);

                  if (!mounted) return;

                  navigator.pop(updatedWorker);

                }               
              }, 
              icon: const Icon(Icons.save),
              label: const Text('Сохранить'),
            ),
          ],
        ),
      ),
    );
  }
}