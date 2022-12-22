import 'package:flutter/material.dart' show ChangeNotifier;
import '../models/app_model.dart';
import '../repositories/app_repository.dart';
import '../utils/api_response.dart';

class AppProvider with ChangeNotifier {
  final AppRepository _appRepository = AppRepository();
  App appConfigs;
  bool spin = false;

  Future<bool> initializeAppConfigs() async {
    try {
      final ApiResponse<App> _res = await _appRepository.getAppConfigs();
      if (!_res.error) {
        if (_res.data != null) {
          appConfigs = _res.data;
          notifyListeners();
          return true;
        }
      }
      return false;
    } catch (e) {
      print(e);
      return false;
    }
  }

  spinState() {
    if (spin == false) {
      spin = true;
      notifyListeners();
    } else {
      spin = false;
      notifyListeners();
    }
  }
}
