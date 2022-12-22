import 'dart:convert' show json;
import 'package:flutter/material.dart' show Locale, Localizations, LocalizationsDelegate, BuildContext;
import 'package:flutter/services.dart' show rootBundle;
import '../constants/config.dart' show appSupportedLocales;

class AppLocalization {
  final Locale locale;

  AppLocalization(this.locale);

  static AppLocalization of(BuildContext context) {
    return Localizations.of<AppLocalization>(context, AppLocalization);
  }

  Map<String, String> _localizedValues;

  Future load() async {
    String langJsonString = await rootBundle
        .loadString('lib/core/lang/${locale.languageCode}.json');
    Map<String, dynamic> mappedLangJson = json.decode(langJsonString);
    _localizedValues =
        mappedLangJson.map((key, value) => MapEntry(key, value.toString()));
  }

  String getTransulatedValue(String key) {
    return _localizedValues[key];
  }

  static const LocalizationsDelegate<AppLocalization> delegate =
      _AppLocalizationDelegate();
}

class _AppLocalizationDelegate extends LocalizationsDelegate<AppLocalization> {
  const _AppLocalizationDelegate();

  @override
  bool isSupported(Locale locale) {
    Locale value = appSupportedLocales.firstWhere(
        (element) => element.languageCode == locale.languageCode,
        orElse: () => null);
    return value != null ? true : false;
  }

  @override
  Future<AppLocalization> load(Locale locale) async {
    AppLocalization localization = new AppLocalization(locale);
    await localization.load();
    return localization;
  }

  @override
  bool shouldReload(_AppLocalizationDelegate old) => false;
}
