import 'dart:io';

import 'package:connectivity/connectivity.dart';
import 'package:feather_icons_flutter/feather_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../ui/screens/common/index.dart' show OfflineScreen;
import '../ui/screens/tabs_screen.dart';
import '../ui/widgets/common/data_loading.dart';
import '../ui/widgets/common/error_message.dart';
import 'common/app_color.dart';
import 'localization/transulation_constants.dart';
import 'providers/app_provider.dart';
import 'router.dart';

class AppBootstrap extends StatelessWidget {
  final ValueNotifier<bool> _initializationNotifier = ValueNotifier(false);

  Widget _scaffold({
    @required Widget child,
    Color color,
  }) {
    return Scaffold(
      backgroundColor: color,
      body: child,
    );
  }

  Widget _checkingConnectivity(BuildContext context) {
    return StreamProvider<ConnectivityResult>(
      create: (BuildContext context) => Connectivity().onConnectivityChanged,
      initialData: null,
      child: Consumer<ConnectivityResult>(
        child: _initializeAppConfig(context),
        builder:
            (BuildContext context, ConnectivityResult results, Widget child) {
          print(results);
          if (results != ConnectivityResult.none) {
            return child;
          } else {
            if (![ConnectivityResult.mobile, ConnectivityResult.wifi]
                .contains(results)) {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                Navigator.popUntil(
                    context, ModalRoute.withName(AppRoutes.root));
              });
            }
            return OfflineScreen();
          }
        },
      ),
    );
  }

  Widget _initializeAppConfig(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: _initializationNotifier,
      builder: (_, __, ___) {
        return FutureBuilder(
          future: Provider.of<AppProvider>(context, listen: false)
              .initializeAppConfigs(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return _scaffold(
                color: AppColors.primaryColor,
                child: DataLoading(
                  color: Colors.white,
                ),
              );
            } else {
              if (snapshot.error != null) {
                return _initializationError(context);
              } else {
                bool _res = snapshot.data as bool;
                return _res ? TabsScreen() : _initializationError(context);
              }
            }
          },
        );
      },
    );
  }

  Widget _initializationError(BuildContext context) {
    return _scaffold(
      color: AppColors.primaryColor,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          ErrorMessage(
            message: transulate(context, 'error_initialize_app_configs'),
            messageColor: Colors.white,
          ),
          SizedBox(
            height: 10,
          ),
          TextButton.icon(
            onPressed: () =>
                _initializationNotifier.value = !_initializationNotifier.value,
            label: Text(
              transulate(context, 'retry'),
              style: TextStyle(
                  fontWeight: FontWeight.w600, color: AppColors.accentColor),
            ),
            icon: Icon(
              FeatherIcons.rotateCcw,
              size: 18,
              color: AppColors.accentColor,
            ),
          ),
        ],
      ),
    );
  }

  Future<bool> _onBackpressed(context) async {
    return await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Do you want to exit?'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.pop(context, false);
              },
              child: Text('No'),
            ),
            TextButton(
                onPressed: () {
                  Navigator.pop(context, false);
                  exit(0);
                },
                child: Text('Exit'))
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () => _onBackpressed(context),
        child: _checkingConnectivity(context));
  }
}
