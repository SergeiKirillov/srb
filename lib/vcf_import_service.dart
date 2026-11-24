import 'package:vcard_dart/vcard_dart.dart';
import 'package:flutter/foundation.dart';

class VcfContactData {
  final String name;
  final DateTime birthday;
  final String shop;
  final String position;
  final String postalCode;
  final String street;

  final int brigade;
  final int grafic7;

  final String phoneMobileWork;
  final String phoneMobilePersonal1;
  final String phoneMobilePersonal2;

  final String phoneWork1;
  final String phoneWork2;
  final String phoneWork3;

  final String phoneShop;

  const VcfContactData({
    required this.name,
    required this.birthday,
    required this.shop,
    required this.position,
    required this.postalCode,
    required this.street,
    required this.brigade,
    required this.grafic7,
    required this.phoneMobileWork,
    required this.phoneMobilePersonal1,
    required this.phoneMobilePersonal2,
    required this.phoneWork1,
    required this.phoneWork2,
    required this.phoneWork3,
    required this.phoneShop,
  });
}

class VcfImportService {
  List<VCard> parse(String content) {
    final parser = VCardParser();
    return parser.parse(content);
  }

  Map<String, int> readNumberBrigade(VCard card) {
    List<String> structuredName = [];

    structuredName = card.name?.suffixes ?? [];

    int brigade = 0;
    int grafic7 = 0;

    for (final item in structuredName) {
      //debugPrint(item);
      final brigadeMatch = RegExp(
        r'бригада\s+(\d+)',
        caseSensitive: false,
      ).firstMatch(item);
      final grafic7Match = RegExp(
        r'график\s(\d+)',
        caseSensitive: false,
      ).firstMatch(item);

      if (brigadeMatch != null) {
        brigade = int.parse(brigadeMatch.group(1)!);
      }
      if (grafic7Match != null) {
        grafic7 = int.parse(grafic7Match.group(1)!);
      }
    }

    debugPrint(brigade.toString());
    debugPrint(grafic7.toString());

    //if (structuredName == null) {return {'numberBrigade': 0, 'numberGrafic7': 0};}

    return {'numberBrigade': brigade, 'numberGrafic7': grafic7};
  }

  String readName(VCard card) {
    final formattedName = card.formattedName.trim();

    //Назначение подполей N (Structured Name):
    //Family Name	        Фамилия
    //Given Name	        Имя
    // Additional Names	  Дополнительные имена
    //Honorific Prefixes	Префикс (г-н, д-р)
    //Honorific Suffixes	Суффикс (кандидат наук, PhD)
    final structuredName = card.name;

    //debugPrint('FN: "$formattedName"');
    //debugPrint('N: "$structuredName"');
    // debugPrint('FN length: ${formattedName.length}');

    if (structuredName == null) {
      return formattedName;
    }

    // final nameFromN =
    //     [structuredName.family, structuredName.given, structuredName.additional]
    //         .where((part) => part is String && part.trim().isNotEmpty)
    //         .map((part) => part.toString().trim())
    //         .join(' ');

    return formattedName;
  }

  //Обработка дня рождения
  //отсутствует всё - текущая дата
  //отсутствует год - подстановка текущего года
  //есть день, месяц, год - форматирование в Datetime.
  DateTime readBirthday(VCard card) {
    final birthday = card.birthday;
    final DateTime now = DateTime.now();

    if (birthday == null || birthday.day == null || birthday.month == null) {
      return DateTime(now.year, now.month, now.day);
    } else if (birthday.year == null) {
      return DateTime(now.year, birthday.month!, birthday.day!);
    }

    try {
      return DateTime(birthday.year!, birthday.month!, birthday.day!);
    } catch (_) {
      return DateTime(now.year, now.month, now.day);
    }
  }

  //Обработка имени организации
  String readShop(VCard card) {
    return card.organization?.name.trim() ?? '';
  }

  //Должность или функциональная обязанность
  String readPosition(VCard card) {
    return card.title?.trim() ?? '';
  }

  String readPostalCode(VCard card) {
    if (card.addresses.isEmpty) {
      return '101400';
    }

    final postalCode = card.addresses.first.postalCode.trim();

    if (postalCode.isEmpty) {
      return '101400';
    }

    return postalCode;
  }

  String readStreet(VCard card) {
    if (card.addresses.isEmpty) {
      return '';
    }
    return card.addresses.first.street.trim();
  }

  Map<String, String> readPhonesFromLabels(String originalVcf) {
    final phones = <String, String>{};
    final lines = originalVcf
        .replaceAll('\r\n ', '')
        .replaceAll('\n ', '')
        .split(RegExp(r'\r?\n'));

    final numbers = <String, String>{};
    final labels = <String, String>{};

    for (final line in lines) {
      final separator = line.indexOf(':');

      if (separator < 0) continue;

      final key = line.substring(0, separator).toUpperCase();
      final value = line.substring(separator + 1).trim();

      final phoneMatch = RegExp(
        r'^(ITEM\d+)\.TEL(?:;[^:]*)?$',
        caseSensitive: false,
      ).firstMatch(key);

      if (phoneMatch != null) {
        numbers[phoneMatch.group(1)!] = value;
      }

      final labelMatch = RegExp(
        r'^(ITEM\d+)\.X-ABLABEL$',
        caseSensitive: false,
      ).firstMatch(key);

      if (labelMatch != null) {
        labels[labelMatch.group(1)!] = value;
      }
    }

    for (final entry in numbers.entries) {
      final label = labels[entry.key]?.toLowerCase();

      switch (label) {
        case 'мобильный':
          phones.putIfAbsent('phoneMobilePersonal2', () => entry.value);
          break;
        case 'рабочий':
          phones.putIfAbsent('phoneMobileWork', () => entry.value);
          break;
      }
    }

    return phones;
  }

  Map<String, String> readPhones(VCard card) {
    //final String phoneMobileWork;
    //final String phoneMobilePersonal1;
    //final String phoneMobilePersonal2;
    //final String phoneWork1;
    //final String phoneWork2;
    //final String phoneWork3;
    //final String phoneShop;

    String mobileWork = '';
    String mobilePersonal1 = '';
    String mobilePersonal2 = '';
    String shopPhone = '';
    final workPhones = <String>[];

    for (final phone in card.telephones) {
      final number = phone.number.trim();
      final types = phone.types.map((type) => type.toLowerCase()).toList();

      if (number.isEmpty) continue;

      // if (types.contains('cell') && types.contains('work')) {
      //   if (mobileWork.isEmpty) {mobileWork = number;}
      // } else if (types.contains('cell') && types.contains('home')) {
      //   if (mobilePersonal1.isEmpty) {mobilePersonal1 = number;}
      // } else if (types.contains('work') && types.contains('voice')) {
      //   if (workPhones.length < 3) {workPhones.add(number);}
      // } else if (types.contains('cell')) {
      //   if (mobilePersonal2.isEmpty) {mobilePersonal2 = number;}
      // }

      if (number.length <= 3) {
        shopPhone = number;
      } else if ((number.length > 3) && (number.length < 7)) {
        workPhones.add(number);
      } else {
        if (types.contains('work')) {
          if (mobileWork.isEmpty) {
            mobileWork = number;
          }
        } else if (types.contains('home')) {
          if (mobilePersonal2.isEmpty) {
            mobilePersonal2 = number;
          }
        } else if (types.contains('cell')) {
          if (mobilePersonal1.isEmpty) {
            mobilePersonal1 = number;
          }
        } else if (types.contains('voice')) {
          workPhones.add(number);
        }
      }

      // if (types.contains('work')) {
      //   if (mobileWork.isEmpty) {mobileWork = number;}
      // } else if (types.contains('home')) {
      //   if (mobilePersonal2.isEmpty) {mobilePersonal2 = number;}
      // } else if (types.contains('voice')) {
      //   if (workPhones.length > 3) {workPhones.add(number);}

      // } else if (types.contains('cell')) {
      //   if (mobilePersonal1.isEmpty) {mobilePersonal1 = number;}
      // }

      // for(final phone in card.telephones){
      //   debugPrint('NUMBER: ${phone.number}');
      //   debugPrint('TYPES: ${phone.types}');
      //   debugPrint('PARAMETERS: ${phone.extension}');
      // }
    }
    return {
      'phoneMobileWork': mobileWork,
      'phoneMobilePersonal1': mobilePersonal1,
      'phoneMobilePersonal2': mobilePersonal2,
      // 'phoneWork1': workPhones.isNotEmpty ? workPhones.first : '',
      // 'phoneWork2': workPhones.length >= 2 ? workPhones[1] : '',
      // 'phoneWork3': workPhones.length >= 3 ? workPhones[2] : '',
      'phoneWork1': workPhones.elementAtOrNull(0) ?? '',
      'phoneWork2': workPhones.elementAtOrNull(1) ?? '',
      'phoneWork3': workPhones.elementAtOrNull(2) ?? '',
      'phoneShop': shopPhone,
    };
  }

  String readBrigade(VCard card) {
    return card.organization?.name.trim() ?? '';
  }

  VcfContactData readContact(VCard card) {
    final phones = readPhones(card);
    final numberBr = readNumberBrigade(card);

    return VcfContactData(
      name: readName(card),
      birthday: readBirthday(card),
      shop: readShop(card),
      position: readPosition(card),
      postalCode: readPostalCode(card),
      street: readStreet(card),

      brigade: numberBr['numberBrigade']!,
      grafic7: numberBr['numberGrafic7']!,

      phoneMobileWork: phones['phoneMobileWork']!,
      phoneMobilePersonal1: phones['phoneMobilePersonal1']!,
      phoneMobilePersonal2: phones['phoneMobilePersonal2']!,
      phoneWork1: phones['phoneWork1']!,
      phoneWork2: phones['phoneWork2']!,
      phoneWork3: phones['phoneWork3']!,
      phoneShop: phones['phoneShop']!,
    );
  }

  List<VcfContactData> readContacts(String content) {
    return parse(content).map((card) => readContact(card)).toList();
  }
}
