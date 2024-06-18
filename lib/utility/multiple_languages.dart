import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:one_my_tasks/main.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Mutlilanguages {

  final Locale locale;

  Mutlilanguages({this.locale = const Locale.fromSubtags(languageCode: 'it')});

  static Mutlilanguages? of (BuildContext context){
    return Localizations.of<Mutlilanguages>(context, Mutlilanguages);
  }

  void keepLocaleKeys(String localeKey) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('localeKey');
    await prefs.setString('localeKey', localeKey);
  }

  Future<String> readLocaleKey() async {

    final prefs = await SharedPreferences.getInstance();

    return prefs.getString('localeKey') ?? 'it';
  }

  void setLocale(BuildContext context, Locale locale) async{
    keepLocaleKeys(locale.languageCode);
    print('***********key languages: ${locale.languageCode}');
    MainApp.setLocale(context, locale);
  }
  
  static const LocalizationsDelegate<Mutlilanguages> delegate = MultiLanguagesDelegate();

  late Map<String, String> _localizedStrings;

  Future<bool> load() async{
    String jsonString = await rootBundle.loadString('languages/${locale.languageCode}.json');
    Map<String, dynamic> jsonMap = json.decode(jsonString);

    _localizedStrings = jsonMap.map((key, value){
      return MapEntry(key, value.toString());
    });

    return true;
  }

  String translate(String key){
    return _localizedStrings[key]!;
  }
}


class MultiLanguagesDelegate extends LocalizationsDelegate<Mutlilanguages>{

  
  const MultiLanguagesDelegate();

  @override
  bool isSupported(Locale locale) {
    return ['it', 'en'].contains(locale.languageCode);
  }

  @override
  Future<Mutlilanguages> load(Locale locale) async{
    Mutlilanguages localizations = Mutlilanguages(locale: locale);
    await localizations.load();
    return localizations;
  }

  @override
  bool shouldReload(covariant LocalizationsDelegate<Mutlilanguages> old) {
    return false;
  }

}