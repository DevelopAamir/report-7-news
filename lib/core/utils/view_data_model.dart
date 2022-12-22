import 'package:flutter/material.dart' show required;

class ViewDataModel<T> {
  List<T> data;
  int page;
  String errorMessage;
  bool isEnd;

  ViewDataModel({
    @required this.data,
    this.page = 1,
    this.errorMessage,
    this.isEnd = false,
  });

  bool isInitRequestError(){
    return page == 1 && data.isEmpty && errorMessage != null;
  }

}
