import 'package:flutter/material.dart' show required;

class ApiResponse<T> {
  T data;
  bool error;
  String message;
  String code;

  ApiResponse({
    @required this.data,
    this.error = false,
    this.message,
    this.code,
  });
}
