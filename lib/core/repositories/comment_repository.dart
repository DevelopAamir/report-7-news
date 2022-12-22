import 'dart:convert' show json;
import 'dart:io' show HttpStatus;
import 'package:flutter/material.dart' show required;
import '../constants/api_endpoints.dart' as endpoints
    show postComments, addPostComment;
import '../models/comment_model.dart';
import '../services/http_service.dart';
import '../utils/api_response.dart';

class CommentRepository {
  final HttpService _httpService = HttpService();

  Future<ApiResponse<List<Comment>>> getPostComments({@required int postId, int page = 1}) async {
    try {
      final _response = await _httpService.getData(path: endpoints.postComments(postId, page));
      final _responseData = json.decode(_response.body);
      if (_response.statusCode == HttpStatus.ok) {
        final List<Comment> _comments = [];
        if (_responseData != null && _responseData.length > 0) {
          _responseData.forEach((comment) {
            _comments.add(Comment.fromApiJson(comment));
          });
        }
        return ApiResponse<List<Comment>>(data: _comments);
      } else {
        final String _errorMsg = _responseData['message'];
        final String _errorCode = _responseData['code'];
        return ApiResponse<List<Comment>>(data: null, error: true, message: _errorMsg, code: _errorCode);
      }
    } catch (error) {
      return ApiResponse<List<Comment>>(data: null, error: true, message: error.toString());
    }
  }

  Future<ApiResponse<Comment>> addPostComments(Map<String, dynamic> body) async {
    try {
      final _response = await _httpService.postData(path: endpoints.addPostComment, body: body);
      final _responseData = json.decode(_response.body);
      if (_response.statusCode == HttpStatus.created) {
        Comment _comments;
        if (_responseData != null) {
          _comments = Comment.fromApiJson(_responseData);
        }
        return ApiResponse<Comment>(data: _comments);
      } else {
        final String _errorMsg = _responseData['message'];
        final String _errorCode = _responseData['code'];
        return ApiResponse<Comment>(data: null, error: true, message: _errorMsg, code: _errorCode);
      }
    } catch (error) {
      return ApiResponse<Comment>(data: null, error: true, message: error.toString());
    }
  }


}
