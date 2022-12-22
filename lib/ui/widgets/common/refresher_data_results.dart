import 'package:flutter/material.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart' show RefreshController, RefreshStatus;
import '../../../core/utils/view_data_model.dart';
import 'error_message.dart';
import 'no_content.dart';

class RefresherDataResults<T> extends StatelessWidget {
  final ViewDataModel<T> viewDataModel;
  final RefreshController controller;
  final Widget results;

  RefresherDataResults({@required this.viewDataModel, @required this.controller, @required this.results});

  @override
  Widget build(BuildContext context) {
    if (viewDataModel.isInitRequestError()) {
      return ErrorMessage(
        message: viewDataModel.errorMessage,
      );
    } else {
      if (viewDataModel.data.isEmpty &&
          controller.headerStatus == RefreshStatus.completed) {
        controller.loadNoData();
        return NoContent();
      }
      return results;
    }
  }
}
