import 'dart:convert' show json;
import 'dart:io' show HttpStatus;
import 'package:flutter/foundation.dart' show required;
import '../constants/api_endpoints.dart' as endpoints show posts;
import '../models/post_model.dart';
import '../services/http_service.dart';
import '../utils/api_response.dart';
import '../constants/config.dart' as config show searchPostsPerPage;

class PostRepository {
  final HttpService _httpService = HttpService();

  Future<ApiResponse<List<Post>>> getPosts({String query}) async {
    try {
      final _response = await _httpService.getData(
          path: endpoints.posts(query != null ? query : ''));
      final _responseData = json.decode(_response.body);
      if (_response.statusCode == HttpStatus.ok) {
        final List<Post> _posts = [];
        if (_responseData != null && _responseData.length > 0) {
          _responseData.forEach((post) {
            _posts.add(Post.fromApiJson(post));
          });
        }
        return ApiResponse<List<Post>>(data: _posts);
      } else {
        final String _errorMsg = _responseData['message'];
        final String _errorCode = _responseData['code'];
        return ApiResponse<List<Post>>(
            data: null, error: true, message: _errorMsg, code: _errorCode);
      }
    } catch (error) {
      return ApiResponse<List<Post>>(
          data: null, error: true, message: error.toString());
    }
  }

  Future<ApiResponse<Post>> getPost(String id) async {
    try {
      final _response =
          await _httpService.getData(path: endpoints.posts('/$id'));
      final _responseData = json.decode(_response.body);
      if (_response.statusCode == HttpStatus.ok) {
        Post _post;
        if (_responseData != null && _responseData.length > 0) {
          _post = Post.fromApiJson(_responseData);
        }
        return ApiResponse<Post>(data: _post);
      } else {
        final String _errorMsg = _responseData['message'];
        final String _errorCode = _responseData['code'];
        return ApiResponse<Post>(
            data: null, error: true, message: _errorMsg, code: _errorCode);
      }
    } catch (error) {
      return ApiResponse<Post>(
          data: null, error: true, message: error.toString());
    }
  }

  Future<ApiResponse<List<Post>>> searchPosts(
      {@required String searchQuery, int page = 1}) async {
    return getPosts(
        query:
            '?search=$searchQuery&page=$page&per_page=${config.searchPostsPerPage}');
  }
}
