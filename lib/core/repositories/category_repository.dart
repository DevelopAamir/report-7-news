import 'dart:convert' show json;
import 'dart:io' show HttpStatus;
import '../constants/api_endpoints.dart' as endpoints show categories;
import '../models/category_model.dart';
import '../services/http_service.dart';
import '../utils/api_response.dart';

class CategoryRepository {
  final HttpService _httpService = HttpService();

  Future<ApiResponse<List<Category>>> getCategories() async {
    try {
      final _response = await _httpService.getData(path: endpoints.categories);
      final _responseData = json.decode(_response.body);
      if (_response.statusCode == HttpStatus.ok) {
        final List<Category> _categories = [];
        if (_responseData != null && _responseData.length > 0) {
          _responseData.forEach((catgory) {
            _categories.add(Category.fromApiJson(catgory));
          });
        }
        return ApiResponse<List<Category>>(data: _categories);
      } else {
        final String _errorMsg = _responseData['message'];
        final String _errorCode = _responseData['code'];
        return ApiResponse<List<Category>>(
            data: null, error: true, message: _errorMsg, code: _errorCode);
      }
    } catch (error) {
      return ApiResponse<List<Category>>(
          data: null, error: true, message: error.toString());
    }
  }
}
