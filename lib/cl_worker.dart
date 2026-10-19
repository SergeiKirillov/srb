class Worker{
  final String id;
  final String name;
  final DateTime birthday;
  final String shop;
  final String position;
  final int brigade;
  final int grafic7;
  final bool working;
  final String phoneMobileWork;
  final String phoneMobilePersonal1;
  final String phoneMobilePersonal2;
  final String phoneWork1;
  final String phoneWork2;
  final String phoneWork3;
  final String phoneShop;

  const Worker({
    required this.id,
    required this.name,
    required this.birthday,
    required this.shop,
    required this.position,
    required this.brigade,
    this.grafic7=0,
    required this.working,
    required this.phoneMobileWork,
    required this.phoneMobilePersonal1,
    required this.phoneMobilePersonal2,
    required this.phoneWork1,
    required this.phoneWork2,
    required this.phoneWork3,
    required this.phoneShop,
  });

  //fromJson() — создаёт работника из записи JSON.
  factory Worker.fromJson(Map<String, dynamic> json){
    return Worker(
      id: json['id'] as String, 
      name: json['name'] as String, 
      birthday: DateTime.parse(json['birthday'] as String), 
      shop: json['shop'] as String, 
      position: json['position'] as String, 
      brigade: json['brigade'] as int, 
      grafic7: json['grafic7'] as int? ?? 0,
      working: json['working'] as bool,
      phoneMobileWork:json['phoneMobileWork'] as String? ?? '',
      phoneMobilePersonal1:json['phoneMobilePersonal1'] as String? ?? '',
      phoneMobilePersonal2:json['phoneMobilePersonal2'] as String? ?? '',
      phoneWork1:json['phoneWork1'] as String? ?? '',
      phoneWork2:json['phoneWork2'] as String? ?? '',
      phoneWork3:json['phoneWork3'] as String? ?? '',
      phoneShop:json['phoneShop'] as String? ?? '',
      );
  }

  //toJson() — преобразует работника обратно в JSON.
  Map<String, dynamic> toJson() {
    final birthdayText = 
      '${birthday.year}-'
      '${birthday.month.toString().padLeft(2,'0')}-'
      '${birthday.day.toString().padLeft(2,'0')}';
    
    return{
      'id':id,
      'name': name, 
      'birthday': birthdayText, 
      'shop': shop, 
      'position': position, 
      'brigade': brigade, 
      'grafic7':grafic7,
      'working': working,
      'phoneMobileWork':phoneMobileWork,
      'phoneMobilePersonal1':phoneMobilePersonal1,
      'phoneMobilePersonal2':phoneMobilePersonal2,
      'phoneWork1':phoneWork1,
      'phoneWork2':phoneWork2,
      'phoneWork3':phoneWork3,
      'phoneShop':phoneShop,
    };
  }
}