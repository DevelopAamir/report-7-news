import 'package:flutter/material.dart';
import '../../../core/localization/transulation_constants.dart';

class ErrorMessage extends StatelessWidget {
  final String message;
  final Color messageColor;
  final double messageSize;

  ErrorMessage({
    this.message,
    this.messageColor,
    this.messageSize,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        message ?? transulate(context, 'general_request_error_msg'),
        style: TextStyle(
          color: messageColor ?? Colors.red,
          fontSize: messageSize ?? 15,
        ),
      ),
    );
  }
}
