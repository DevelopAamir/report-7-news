import 'package:flutter/material.dart' show BuildContext, TextDirection, Directionality;
import 'package:timeago/timeago.dart' as timeago;
import 'app_localization.dart';

/// Method to get the transulated value of the given key
///
/// Accept [context] to be passd to be passed to app localization
/// Accept [key] to get the transulated value of it
String transulate(BuildContext context, String key){
  String _transulated = AppLocalization.of(context).getTransulatedValue(key);
  return _transulated != null ? _transulated : key;
}

/// Formats and transulate provided [date] to a fuzzy time like 'a moment ago'
String formatTimeAgeValue(BuildContext context, DateTime date){
  String lang = AppLocalization.of(context).locale.languageCode;
  return timeago.format(date, locale: lang);
}

/// Check if the current layout direction is RTL
/// Accept [context] to be passd
bool isRTL(BuildContext context){
  final TextDirection currentDirection = Directionality.of(context);
  return currentDirection == TextDirection.rtl;
}