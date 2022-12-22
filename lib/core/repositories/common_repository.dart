import 'dart:convert' show json;
import 'dart:io' show HttpStatus;
import '../constants/api_endpoints.dart' as endpoints show page, contact;
import '../models/page_model.dart';
import '../services/http_service.dart';
import '../utils/api_response.dart';

class CommonRepository {
  final HttpService _httpService = HttpService();

  Future<ApiResponse<Page>> getPage(int pageId) async {
    try {
      final _response =
          await _httpService.getData(path: endpoints.page(pageId));
      final _responseData = json.decode(_response.body);
      if (_response.statusCode == HttpStatus.ok) {
        final _responseData = json.decode(_response.body);
        Page _page;
        if (_responseData != null) {
          _page = Page.fromApiJson(_responseData);
        }
        return ApiResponse<Page>(data: _page);
      } else {
        final String _errorMsg = _responseData['message'];
        final String _errorCode = _responseData['code'];
        return ApiResponse<Page>(
            data: null, error: true, message: _errorMsg, code: _errorCode);
      }
    } catch (error) {
      return ApiResponse<Page>(
          data: null, error: true, message: error.toString());
    }
  }

  Future<ApiResponse<bool>> sendContactMessage(
      Map<String, dynamic> body, int formId) async {
    try {
      final _response = await _httpService.postData(
          path: endpoints.contact(formId), body: body);
      final _responseData = json.decode(_response.body);
      if (_response.statusCode == HttpStatus.ok) {
        if (_responseData != null && _responseData['status'] == 'mail_sent') {
          return ApiResponse<bool>(data: true);
        } else {
          return ApiResponse<bool>(data: false, error: true);
        }
      } else {
        final String _errorMsg = _responseData['message'];
        final String _errorCode = _responseData['status'];
        return ApiResponse<bool>(
            data: false, error: true, message: _errorMsg, code: _errorCode);
      }
    } catch (error) {
      return ApiResponse<bool>(
          data: false, error: true, message: error.toString());
    }
  }
}
