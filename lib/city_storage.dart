import 'dart:convert';
import 'dart:io';

import 'package:path_provider/path_provider.dart';

import 'cl_city.dart';

class CityStorage {
  Future<File> _getFile() async{
    final direcotry =await getApplicationDocumentsDirectory();
    return File('${direcotry.path}/cities.json');

  }

  Future<List<City>> loadCities() async {
    final file = await _getFile();

    if(!await file.exists()){
      final cities = [
        const City(
          postalCode: '101400', name: 'Темиртау', phoneCode: '+77213',)
      ];
      await saveCities(cities);
      return cities;

    }

    final jsonText = await file.readAsString();
    final List<dynamic> data = jsonDecode(jsonText);

    final cities = data.map((item){
      return City.fromJson(
        Map<String,dynamic>.from(item as Map),
        );
    }).toList();

    final postalCodes = cities.map((city)=> city.postalCode).toSet();
    
    if (postalCodes.length != cities.length) {
      throw FormatException(
        'В справочнике городов обнаружены повторяющиеся почтовые индексы.',
      );
    }

    return cities;
  }

  Future<void> saveCities(List<City> cities) async {
    final postalCodes = cities.map((city) => city.postalCode).toSet();

    if (postalCodes.length != cities.length){
      throw ArgumentError(
        'почтовые индексы городов должны быть уникальными.'
      );
    }

    final file = await _getFile();
    final data = cities.map((city) => city.toJson()).toList();
    final jsonText = const JsonEncoder.withIndent(' ').convert(data);

    await file.writeAsString(jsonText);
  }
  
}

