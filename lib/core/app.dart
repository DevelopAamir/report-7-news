import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';
import 'package:report7news/core/repositories/auth_repo.dart';
import 'package:report7news/core/services/localstorage_service.dart';
import 'package:report7news/ui/screens/login.dart.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'app_bootstrap.dart';
import 'common/app_theme.dart';
import 'constants/config.dart' show appLocale, appSupportedLocales;
import 'localization/app_localization.dart';
import 'providers/app_provider.dart';
import 'providers/favorite_provider.dart';
import 'router.dart';

class App extends StatelessWidget {
  /// Method to set the locale of the time age package
  void setTimeAgoLocale() {
    timeago.setLocaleMessages('en', timeago.EnMessages());
    timeago.setLocaleMessages('en_short', timeago.EnShortMessages());
  }

  @override
  Widget build(BuildContext context) {
    setTimeAgoLocale();
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<AppProvider>(
          create: (_) => AppProvider(),
          lazy: false,
        ),
        ChangeNotifierProvider<FavoriteProvider>(
          create: (_) => FavoriteProvider(),
          lazy: false,
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Lucodeia News',
        theme: appTheme,
        localizationsDelegates: [
          AppLocalization.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
          DefaultCupertinoLocalizations.delegate
        ],
        locale: appLocale,
        supportedLocales: appSupportedLocales,
        home: LoggedInState(),
        onGenerateRoute: AppRouter.generateRoute,
      ),
    );
  }
}

class LoggedInState extends StatefulWidget {
  @override
  _LoggedInStateState createState() => _LoggedInStateState();
}

class _LoggedInStateState extends State<LoggedInState> {
  AuthRepo data = AuthRepo();
  Widget currentPage = Scaffold(
      body: Container(
          color: Colors.indigo,
          child: Center(child: Image.asset('assets/images/logo.jpg'))));
  @override
  void initState() {
    super.initState();
    Timer(Duration(seconds: 3), () {
      checkLogin();
    });
  }

  checkLogin() async {
    String catogary = await data.getData();

    if (catogary != null) {
      setState(() {
        currentPage = AppBootstrap();
      });
    } else {
      setState(() {
        currentPage = Login();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return currentPage;
  }
}
