import 'package:flutter/material.dart';
import 'package:srb/city_storage.dart';
import 'cl_worker.dart';
import 'package:url_launcher/url_launcher.dart';
import 'worker_form_page.dart';



class WorkerDetailPage extends StatelessWidget{
  final Worker worker;

  const WorkerDetailPage({
    super.key,
    required this.worker,
  });

  String? preparePhoneNumber(String phone, {required bool mobile}){
    final value = phone.trim();

    if (value.isEmpty) return null;

    if (mobile) {
      //Мобильный номер должен быть в формате +7 ХХХ ХХХ ХХ ХХ .

      final normalized = value.replaceAll(RegExp(r'\s+'), '');

      if(RegExp(r'^\+7\d{10}$').hasMatch(normalized)){
        return normalized;
      }
      return null;
    }

    //Рабочий городской номер: 6 цифр + код Казахстана и города
    if (RegExp(r'^\d{6}$').hasMatch(value)){
      return '+77213$value';
    } 

    return null;

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Карточка работника'),
        actions: [
          IconButton(
            tooltip: 'Редактировать',
            icon: const Icon(Icons.edit),
            onPressed: () async {
              //Открытие формы для редактирования 
              final updatedWorker =await Navigator.push<Worker>(
                context, 
                MaterialPageRoute(
                  builder: (context)=>WorkerFormPage(
                    worker:worker,
                    onSave: (updatedWorker) async {
                      // Сохранение списка подключается на экране «Все работники».
                    },
                  ),
                ),
              );
              if (!context.mounted || updatedWorker ==null) return;
              Navigator.pop(context, updatedWorker);
            },
          ),
        ],
      ),
      body: SafeArea(
        child: ListView(
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
              leading: const Icon(Icons.location_on),
              title: const Text('Адрес'),
              subtitle: FutureBuilder(
                future: CityStorage().loadCities(), 
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting){
                    return const Text('Загрузка адреса...');
                  }    
                  if (snapshot.hasError){
                    return const Text('Ошибка загрузки адреса');
                  }
                  final cities = snapshot.data ?? [];

                  final matchingCities = cities.where(
                    (city)=>city.postalCode == worker.cityPostalCode,
                  );

                  final cityName = matchingCities.isNotEmpty ? matchingCities.first.name : 'Город не найден';

                  final addressParts = <String> [
                    cityName,
                    if(worker.street.isNotEmpty) 'ул. ${worker.street}',
                    if(worker.house.isNotEmpty) 'д. ${worker.house}',
                    if(worker.apartment.isNotEmpty) 'кв. ${worker.apartment}',
                  ];

                  return Text(addressParts.join(', '));

                },
              ),    
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
            ),

            const Divider(),

            const Padding(
              padding: EdgeInsets.all(16),
              child: Text(
                'Телефоны',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

            WorkerPhoneTile(
              title: 'Рабочий мобильный', 
              phone: worker.phoneMobileWork,
              mobile: true,
              cityPostalCode: worker.cityPostalCode,
            ),

            WorkerPhoneTile(
              title: 'Личный мобильный 1', 
              phone: worker.phoneMobilePersonal1,
              mobile: true,
              cityPostalCode: worker.cityPostalCode,
            ),

            WorkerPhoneTile(
              title: 'Личный мобильный 2', 
              phone: worker.phoneMobilePersonal2,
              mobile: true,
              cityPostalCode: worker.cityPostalCode,
            ),

            WorkerPhoneTile(
              title: 'Рабочий телефон 1', 
              phone: worker.phoneWork1,
              cityPostalCode: worker.cityPostalCode,
            ),

            WorkerPhoneTile(
              title: 'Рабочий телефон 2', 
              phone: worker.phoneWork2,
              cityPostalCode: worker.cityPostalCode,
            ),

            WorkerPhoneTile(
              title: 'Рабочий телефон 3', 
              phone: worker.phoneWork3,
              cityPostalCode: worker.cityPostalCode,
            ),

            WorkerPhoneTile(
              title: 'Цеховой телефон', 
              phone: worker.phoneShop,
              cityPostalCode: worker.cityPostalCode,
            ),

          ],
        ),
      ),
    );
  }
}

class WorkerPhoneTile extends StatelessWidget {
  final String title;
  final String phone;
  final bool mobile;
  final String cityPostalCode;

  const WorkerPhoneTile({
    super.key,
    required this.title,
    required this.phone,
    this.mobile = false,
    required this.cityPostalCode,
  });

  String? preparePhoneNumber(){
    final value = phone.trim();

    if(value.isEmpty) return null;

    if(mobile){
      final normalized = value.replaceAll(RegExp(r'\s+'), '');

      if(RegExp(r'^\+7\d{10}$').hasMatch(normalized)){
        return normalized;
      }
      return null;
    }

    final digits = value.replaceAll(RegExp(r'\s+'), '');
    if(RegExp(r'^96\d{4}$').hasMatch(digits)){
      //return '+77213$value';
      return digits;
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final value = phone.trim();

    if(value.isEmpty){
      return const SizedBox.shrink();
    }

    final number = preparePhoneNumber();
    final isInternal = !mobile && RegExp(r'^\d{3}$').hasMatch(value);

    return ListTile(
      leading: const Icon(Icons.phone),
      title: Text(title),
      subtitle: Text(
        isInternal?'$value (внутренний номер)': number == null ? '$value (неверный формат номера)':value,
      ),
      trailing: number == null
        ?null
        :IconButton(
          icon: const Icon(Icons.call),
          tooltip: 'Позвонить',
          onPressed: () async {
            String dialNumber = number;

            if(!mobile){
              try {
                final cities = await CityStorage().loadCities();

                final matchingCities = cities.where(
                  (city) => city.postalCode == cityPostalCode,
                );

                if( matchingCities.isEmpty || matchingCities.first.phoneCode.trim().isEmpty){
                  if(context.mounted){
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text(
                          'Не найден телефонный код города. '
                          'Проверте справичник городов.'
                        ),
                      ),
                    );
                  }
                  return;
                } 
                
                final phoneCode = matchingCities.first.phoneCode.trim();

                if(!RegExp(r'^\+\d+$').hasMatch(phoneCode)){
                  if(context.mounted){
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Неверный телефонный код города.'),
                      ),
                    );
                  }
                  return;
                }
                
                dialNumber = '$phoneCode$number';
              } catch (_) {
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Не удалось загрузить справочник городов'),
                    ),
                  );
                }
                return;
              }
            }
            final uri = Uri(
              scheme: 'tel',
              path: dialNumber,
            );

            try {
              final launched  = await launchUrl(uri);
              if (!launched && context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Не удалось открыть приложение телефона'),
                  ),
                );
              }
            } catch (_) {
              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Ошибка при открытии приложения телефона'),
                  ),
                );
              }
            }
          },
        ),
    );
  }
}