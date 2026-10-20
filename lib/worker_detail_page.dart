import 'package:flutter/material.dart';
import 'cl_worker.dart';
import 'package:url_launcher/url_launcher.dart';

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
      //Мобильный номер должен быть в формате +7ХХХХХХХХХХХ .
      if(RegExp(r'^\+7\d{10}$').hasMatch(value)){
        return value;
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
          ),

          WorkerPhoneTile(
            title: 'Личный мобильный 1', 
            phone: worker.phoneMobilePersonal1,
            mobile: true,
          ),

          WorkerPhoneTile(
            title: 'Личный мобильный 2', 
            phone: worker.phoneMobilePersonal2,
            mobile: true,
          ),

          WorkerPhoneTile(
            title: 'Рабочий телефон 1', 
            phone: worker.phoneWork1,
          ),

          WorkerPhoneTile(
            title: 'Рабочий телефон 2', 
            phone: worker.phoneWork2,
          ),

          WorkerPhoneTile(
            title: 'Рабочий телефон 3', 
            phone: worker.phoneWork3,
          ),

          WorkerPhoneTile(
            title: 'Цеховой телефон', 
            phone: worker.phoneShop,
          ),

        ],
      ),
    );
  }
}

class WorkerPhoneTile extends StatelessWidget {
  final String title;
  final String phone;
  final bool mobile;

  const WorkerPhoneTile({
    super.key,
    required this.title,
    required this.phone,
    this.mobile = false,
  });

  String? preparePhoneNumber(){
    final value = phone.trim();

    if(value.isEmpty) return null;

    if(mobile){
      if(RegExp(r'^\+7\d{10}$').hasMatch(value)){
        return value;
      }
      return null;
    }

    if(RegExp(r'^\d{6}$').hasMatch(value)){
      return '+77213$value';
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
            final uri = Uri(
              scheme: 'tel',
              path: number,
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