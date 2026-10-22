import 'package:flutter/material.dart';

class WorkerFormPage extends StatefulWidget{
  
  const WorkerFormPage({super.key});

  @override
  State<WorkerFormPage> createState()=>_WorkerFormPageState();

}

class _WorkerFormPageState extends State<WorkerFormPage>{
  final _nameController =TextEditingController();
  final _shopController = TextEditingController();
  final _positionController = TextEditingController();

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
        title: Text('Новый работник'),
      ),
      body: Form(
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
          ],
        ),
      ),
    );
  }
}