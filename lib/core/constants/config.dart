import 'package:flutter/material.dart' show Locale;


const Map<String, String> environment = {
  'url': 'https://report7news.com',
};

//Locale('en', 'US'),
const Locale appLocale = Locale('en', 'US');
const List<Locale> appSupportedLocales = [Locale('en', 'US')];

const String storageKey = 'report7_wpnews';
const String imagePlaceholder = 'assets/images/default-placeholder.png';
const int postsPerPage = 10;
const int searchPostsPerPage = 10;
const int commentsPerPage = 10;
