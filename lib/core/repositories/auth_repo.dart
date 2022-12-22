import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:report7news/core/services/http_service.dart';
import 'package:report7news/core/utils/api_response.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../app.dart';
import '../constants/api_endpoints.dart' as endpoints show login;

class AuthRepo {
  final HttpService _httpService = HttpService();
  final storage = FlutterSecureStorage();
  Future<ApiResponse> login() async {
    try {
      final _response = await _httpService.getData(path: endpoints.login);
      if (_response.statusCode == HttpStatus.ok) {
        final _responseData = json.decode(_response.body);
        return ApiResponse(data: _responseData);
      } else {
        return ApiResponse<App>(
            data: null, error: true, message: 'Error logging in');
      }
    } catch (error) {
      print(error);
      return ApiResponse<App>(
          data: null, error: true, message: error.toString());
    }
  }

  bool isLoggedIn() {
    return false;
    //return sharedPreferences.containsKey(AppConstants.TOKEN);
  }

  Future<void> storeData(String loggedinUser) async {
    await storage.write(key: 'user', value: loggedinUser);
  }

  Future<String> getData() async {
    return await storage.read(key: 'user');
  }

  Future<void> logOut() async {
    try {
      await storage.delete(key: 'user');
    } catch (e) {
      print(e);
    }
  }
}
