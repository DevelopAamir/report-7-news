import 'package:flutter/material.dart';
import '../../../core/common/app_color.dart';
import '../../../core/localization/transulation_constants.dart';

class NoContent extends StatelessWidget {
  final String message;
  final Color messageColor;
  final double messageSize;
  final IconData icon;

  NoContent({
    this.message,
    this.messageColor,
    this.messageSize,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          if (icon != null)
            Padding(
              padding: const EdgeInsets.only(bottom: 15),
              child: Icon(
                icon,
                size: 40,
                color: AppColors.primaryColor,
              ),
            ),
          Text(
            message ?? transulate(context, 'general_no_content_msg'),
            style: TextStyle(
              color: messageColor ?? AppColors.fontColor,
              fontSize: messageSize ?? 15,
            ),
          ),
        ],
      ),
    );
  }
}
