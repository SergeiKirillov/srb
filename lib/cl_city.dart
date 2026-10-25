class City{
  final String postalCode;
  final String name;
  final String phoneCode;

  const City({
    required this.postalCode,
    required this.name,
    required this.phoneCode,
  });

  factory City.fromJson(Map<String,dynamic> json) {
    return City(
      postalCode: json['postalCode'] as String,
      name: json['name'] as String,
      phoneCode: json['phoneCode'] as String,
    );
  }

  Map<String, dynamic> toJson(){
    return {
      'postalCode':postalCode,
      'name':name,
      'phoneCode':phoneCode,
    };
  }



  
}