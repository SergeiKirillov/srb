import 'package:vcard_dart/vcard_dart.dart';

class VcfContactData {
  final String name;
  final DateTime birthday;
  final String shop;
  final String position; 
  final String postalCode;
  final String street;

  final String phoneMobileWork;
  final String phoneMobilePersonal1;
  final String phoneMobilePersonal2;

  final String phoneWork1;
  final String phoneWork2;
  final String phoneWork3;

  const VcfContactData({
    required this.name,
    required this.birthday,
    required this.shop,
    required this.position,
    required this.postalCode,
    required this.street,
    required this.phoneMobileWork,
    required this.phoneMobilePersonal1,
    required this.phoneMobilePersonal2,
    required this.phoneWork1,
    required this.phoneWork2,
    required this.phoneWork3,
  });
}

class VcfImportService {
  List<VCard> parse(String content){
    final parser = VCardParser();
    return parser.parse(content);
  }

  String readName(VCard card){

    final formattedName = card.formattedName.trim();

    if (formattedName.isNotEmpty){
      return formattedName;
    }

    final name = card.name;

    if(name ==null) {
      return '';
    }

    return [
      name.family, 
      name.given,
      name.additional,
    ]
    .where((part) => part is String && part.trim().isNotEmpty)
    .map((part)=>part.toString().trim())
    .join(' ');
  }

  DateTime readBirthday(VCard card){
    final birthday = card.birthday;

    if(birthday == null ||
      birthday.year == null ||
      birthday.month == null ||
      birthday.day == null){
        return DateTime.now();
    } 

    try {
      return DateTime(
        birthday.year!,
        birthday.month!,
        birthday.day!,
      );
    } catch (_) {
      return DateTime.now();
    }
  }

  String readShop(VCard card){
    return card.organization?.name.trim() ?? '';
  }

  String readPosition(VCard card){
    return card.title?.trim() ?? '';
  }

  String readPostalCode(VCard card){
    
    if (card.addresses.isEmpty) {
      return '101400';
    }

    final postalCode =card.addresses.first.postalCode.trim();
     
    if(postalCode.isEmpty){
      return '101400';
    }

    return postalCode;
  }

  String readStreet(VCard card){
    if(card.addresses.isEmpty){
      return '';
    }
    return card.addresses.first.street.trim();
  }

  Map<String, String> readPhones(VCard card) {
    String mobileWork = '';
    String mobilePersonal1 = '';
    String mobilePersonal2 = '';

    final workPhones = <String>[];

    for (final phone in card.telephones) {
      final number = phone.number.trim();
      final types = phone.types.map((type)=>type.toLowerCase()).toList();

      if (number.isEmpty) continue;

      if(types.contains('cell')&& types.contains('work')) {
        if (mobileWork.isEmpty){
          mobileWork = number;
        }
      } else if (types.contains('cell') && types.contains('home')){
        if (mobilePersonal1.isEmpty) {
          mobilePersonal1 =number;
        }
      } else if (types.contains('work') && types.contains('voice')){
        if(workPhones.length <3){
          workPhones.add(number);
        }
      } else if (types.contains('cell')){
        if(mobilePersonal2.isEmpty) {
          mobilePersonal2 =number;
        }
      }
    }
    return {
      'phoneMobileWork':mobileWork,
      'phoneMobilePersonal1':mobilePersonal1,
      'phoneMobilePersonal2':mobilePersonal2,
      'phoneWork1':workPhones.isNotEmpty ? workPhones.first : '',
      'phoneWork2':workPhones.length >= 2 ? workPhones[1]:'',
      'phoneWork3':workPhones.length >= 3 ? workPhones[2]:'',
    };
  }

  VcfContactData readContact(VCard card){
    final phones =readPhones(card);

    return VcfContactData(
      name: readName(card), 
      birthday: readBirthday(card), 
      shop: readShop(card), 
      position: readPosition(card), 
      postalCode: readPostalCode(card), 
      street: readStreet(card), 
      phoneMobileWork: phones['phoneMobileWork']!, 
      phoneMobilePersonal1: phones['phoneMobilePersonal1']!, 
      phoneMobilePersonal2: phones['phoneMobilePersonal2']!, 
      phoneWork1: phones['phoneWork1']!, 
      phoneWork2: phones['phoneWork2']!, 
      phoneWork3: phones['phoneWork3']!,
    );
  }

  List<VcfContactData> readContacts(String content){
    return parse(content)
    .map((card) => readContact(card))
    .toList();
  }
}

