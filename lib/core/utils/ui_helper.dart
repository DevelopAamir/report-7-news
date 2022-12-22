import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart'
    show CustomFooter, LoadStatus;
import '../../ui/widgets/common/data_loading.dart';

void presentToast({
  @required String message,
  bool success = true,
}) {
  Fluttertoast.showToast(
    msg: message,
    toastLength: Toast.LENGTH_LONG,
    gravity: ToastGravity.SNACKBAR,
    timeInSecForIosWeb: 1,
    backgroundColor: success ? Colors.green : Colors.red,
    textColor: Colors.white,
    fontSize: 16.0,
  );
}

Widget smartRefresherFooter() {
  return CustomFooter(
    builder: (BuildContext context, LoadStatus mode) {
      if (mode == LoadStatus.loading) {
        return Center(
          child: SizedBox(
            width: 20,
            height: 20,
            child: CircularProgressIndicator(
              strokeWidth: 3,
            ),
          ),
        );
      }
      return SizedBox();
    },
  );
}

Widget buttonLoadingState() {
  return SizedBox(
    width: 20,
    height: 20,
    child: CircularProgressIndicator(
      strokeWidth: 2,
    ),
  );
}

void showLoadingDialog(BuildContext context) {
  showDialog(
    barrierDismissible: false,
    context: context,
    builder: (BuildContext context) {
      return DataLoading();
    },
  );
}

void hideLoadingDialog(BuildContext context) {
  Navigator.of(context).pop();
}
