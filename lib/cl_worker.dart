class Worker{
  final String id;
  final String name;
  final DateTime birthday;
  final String shop;
  final String position;
  final String phone;
  final int brigade;
  final bool working;

  const Worker({
    required this.id,
    required this.name,
    required this.birthday,
    required this.shop,
    required this.position,
    required this.phone,
    required this.brigade,
    required this.working,
  });

  //fromJson() — создаёт работника из записи JSON.
  factory Worker.fromJson(Map<String, dynamic> json){
    return Worker(
      id: json['id'] as String, 
      name: json['name'] as String, 
      birthday: DateTime.parse(json['birthday'] as String), 
      shop: json['shop'] as String, 
      position: json['position'] as String, 
      phone: json['phone'] as String, 
      brigade: json['brigade'] as int, 
      working: json['working'] as bool,
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
      'phone': phone, 
      'brigade': brigade, 
      'working': working,
    };
  }
}