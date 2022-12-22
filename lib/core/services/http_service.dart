import 'package:flutter/material.dart' show required;
import 'package:http/http.dart' as http;
import '../constants/config.dart' show environment;

class HttpService {
  /// A middleware to make HTTP GET request
  /// Required [path] string to http request
  /// Accept [headers] to be set to the request
  /// Return a Future of http Response for the request
  Future<http.Response> getData({
    @required String path,
    Map<String, String> headers,
  }) {
    return http.get(Uri.parse(environment['url'] + path), headers: headers);
  }

  /// A middleware to make HTTP POST request
  /// Required [path] string to http request
  /// Accept [headers] to be set to the request
  /// Return a Future of http Response for the request
  Future<http.Response> postData({
    @required String path,
    Map<String, String> headers,
    Map<String, dynamic> body,
  }) {
    return http.post(Uri.parse(environment['url'] + path),
        headers: headers, body: body);
  }
}
