import 'dart:convert' show json;
import 'dart:io' show HttpStatus;
import '../constants/api_endpoints.dart' as endpoints
    show appOptions;
import '../models/app_model.dart';
import '../services/http_service.dart';
import '../utils/api_response.dart';

class AppRepository {
  final HttpService _httpService = HttpService();

  Future<ApiResponse<App>> getAppConfigs() async {
    try {
      final _response = await _httpService.getData(path: endpoints.appOptions);
      if (_response.statusCode == HttpStatus.ok) {
        final _responseData = json.decode(_response.body);
        final App _categories = App.fromApiJson(_responseData);
        return ApiResponse<App>(data: _categories);
      } else {
        return ApiResponse<App>(data: null, error: true, message: 'Error fetching app config');
      }
    } catch (error) {
      print(error);
      return ApiResponse<App>(data: null, error: true, message: error.toString());
    }
  }


}
