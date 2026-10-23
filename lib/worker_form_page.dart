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
  final _phoneMobileWorkController = TextEditingController();
  final _phoneMobilePersonal1Controller = TextEditingController();
  final _phoneMobilePersonal2Controller = TextEditingController();
  final _phoneWork1Controller = TextEditingController();
  final _phoneWork2Controller = TextEditingController();
  final _phoneWork3Controller = TextEditingController();
  final _phoneShopController = TextEditingController();
  DateTime _birthday = DateTime(2000,1,1);
  int _brigade = 5;
  int _grafic7 = 0;
  bool _working = true;

  @override
  void initState() {
    super.initState();

    final worker = widget.worker;

    if (worker != null) {
      _nameController.text = worker.name;
      _shopController.text = worker.shop;
      _positionController.text = worker.position;
      _birthday = widget.worker!.birthday;
      _brigade = widget.worker!.brigade;
      _grafic7 = widget.worker!.grafic7;
      _working = widget.worker!.working;
      _phoneMobileWorkController.text = widget.worker!.phoneMobileWork;
      _phoneMobilePersonal1Controller.text = widget.worker!.phoneMobilePersonal1;
      _phoneMobilePersonal2Controller.text = widget.worker!.phoneMobilePersonal2;
      _phoneWork1Controller.text = widget.worker!.phoneWork1;
      _phoneWork2Controller.text = widget.worker!.phoneWork2;
      _phoneWork3Controller.text = widget.worker!.phoneWork3;
      _phoneShopController.text = widget.worker!.phoneShop;
      



    }
  }

  @override
  void dispose(){
    _nameController.dispose();
    _shopController.dispose();
    _positionController.dispose();
    _phoneMobileWorkController.dispose();
    _phoneMobilePersonal1Controller.dispose();
    _phoneMobilePersonal2Controller.dispose();
    _phoneWork1Controller.dispose();
    _phoneWork2Controller.dispose();
    _phoneWork3Controller.dispose();
    _phoneShopController.dispose();
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
            ListTile(
              title: const Text('Дата рождения'),
              subtitle: Text(
                '${_birthday.day.toString().padLeft(2,'0')}.'
                '${_birthday.month.toString().padLeft(2,'0')}.'
                '${_birthday.year}'
              ),
              trailing: const Icon(Icons.calendar_month),
              onTap: () async{
                final selectedDate = await showDatePicker(
                  context: context, 
                  initialDate: _birthday,
                  firstDate: DateTime(1900), 
                  lastDate: DateTime.now(),
                );
                if (selectedDate != null && mounted) {
                  setState(() {
                    _birthday = selectedDate;
                  });
                }
              },
            ),
            
            DropdownButtonFormField(
              initialValue: _brigade,
              decoration: const InputDecoration(
                labelText: 'Бригада',
                border: OutlineInputBorder(),
              ),
              items: List.generate(5, (index) {
                final brigade =index+1;
                return DropdownMenuItem<int>(
                  value: brigade,
                  child: Text('Бригада $brigade'),
                );
              }), 
              onChanged: (value) {
                if(value != null){
                  setState(() {
                    _brigade=value;
                  });
                }
              }
            ),

            if(_brigade == 5) ...[
              const SizedBox(height: 16),
              DropdownButtonFormField<int>(
                initialValue: _grafic7,
                decoration: const InputDecoration(
                  labelText: 'График работы',
                  border: OutlineInputBorder(),
                ),
                items: const [
                  DropdownMenuItem(
                    value: 0,
                    child: Text('Понедельник-пятница'),
                  ),
                  DropdownMenuItem(
                    value:1,
                    child: Text('7-й график -- понедельник-суббота'),
                  ),
                  DropdownMenuItem(
                    value:2,
                    child: Text('7-й график -- воскреснье-пятница'),
                  ),
                ], 
                onChanged: (value) {
                  if (value!=null) {
                    setState(() {
                      _grafic7 = value;
                    });
                  }
                },
              ),
            ], 

            SwitchListTile(
              title: const Text('Работает'),
              value: _working,
              onChanged: (value){
                setState(() {
                  _working=value;
                });
              },
            ),

            TextFormField(
              controller: _phoneMobileWorkController,
              decoration: const InputDecoration(
                labelText: 'Рабочий мобильный номер',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.phone,
            ),
            const SizedBox(height: 12,),
            TextFormField(
              controller: _phoneMobilePersonal1Controller,
              decoration: const InputDecoration(
                labelText: 'Личный мобильный номер №1',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12,),
            TextFormField(
              controller: _phoneMobilePersonal2Controller,
              decoration: const InputDecoration(
                labelText: 'Личный мобильный номер №2',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.phone,
            ),
            const SizedBox(height: 12,),
            TextFormField(
              controller: _phoneWork1Controller,
              decoration: const InputDecoration(
                labelText: 'Рабочий телефон № 1',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.phone,
            ),
            const SizedBox(height: 12,),
            TextFormField(
              controller: _phoneWork2Controller,
              decoration: const InputDecoration(
                labelText: 'Рабочий телефон № 2',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.phone,
            ),
            const SizedBox(height: 12,),
            TextFormField(
              controller: _phoneWork3Controller,
              decoration: const InputDecoration(
                labelText: 'Рабочий телефон № 3',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.phone,
            ),
            const SizedBox(height: 12,),
            TextFormField(
              controller: _phoneShopController,
              decoration: const InputDecoration(
                labelText: 'Диспетческий телефон',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.phone,
            ),
            const SizedBox(height: 12,),


            
            
            
            const SizedBox(height: 16,),

            //------------------------------------------
            const SizedBox(height: 24,),
            FilledButton.icon(
              onPressed: () async {
                if(_formKey.currentState!.validate()){
                  // Сохранение.
                  final oldWorker = widget.worker;

                  if(oldWorker==null){
                    final newWorker = Worker(
                      id: 'W${DateTime.now().microsecondsSinceEpoch}', 
                      name: _nameController.text.trim(), 
                      birthday: _birthday, 
                      shop: _shopController.text.trim(), 
                      position: _positionController.text.trim(), 
                      brigade: _brigade, 
                      grafic7: _brigade==5 ? _grafic7 : 0 ,
                      working: _working, 
                      phoneMobileWork: _phoneMobileWorkController.text.trim(), 
                      phoneMobilePersonal1: _phoneMobilePersonal1Controller.text.trim(), 
                      phoneMobilePersonal2: _phoneMobilePersonal2Controller.text.trim(), 
                      phoneWork1: _phoneWork1Controller.text.trim(), 
                      phoneWork2: _phoneWork2Controller.text.trim(), 
                      phoneWork3: _phoneWork3Controller.text.trim(), 
                      phoneShop: _phoneShopController.text.trim(),
                    );
                    
                    final navigator=Navigator.of(context);

                    await widget.onSave(newWorker);

                    if(!mounted) return; 

                    //ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Добавление нового работника подключим далее'),),);
                    navigator.pop(newWorker);

                    return;
                  }

                  final updatedWorker = Worker(
                    id: oldWorker.id, 
                    name: _nameController.text.trim(), 
                    birthday: _birthday, 
                    shop: _shopController.text.trim(), 
                    position: _positionController.text.trim(), 
                    brigade: _brigade, 
                    grafic7: _brigade==5?_grafic7:0,
                    working: _working, 
                    phoneMobileWork: _phoneMobileWorkController.text.trim(), 
                    phoneMobilePersonal1: _phoneMobilePersonal1Controller.text.trim(), 
                    phoneMobilePersonal2: _phoneMobilePersonal2Controller.text.trim(), 
                    phoneWork1: _phoneWork1Controller.text.trim(), 
                    phoneWork2: _phoneWork2Controller.text.trim(), 
                    phoneWork3: _phoneWork3Controller.text.trim(), 
                    phoneShop: _phoneShopController.text.trim(),
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