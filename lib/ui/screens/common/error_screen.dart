import 'package:flutter/material.dart';
import 'package:feather_icons_flutter/feather_icons_flutter.dart';
import '../../../core/common/app_color.dart';
import '../../../core/localization/transulation_constants.dart';

class ErrorScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(0),
        child: AppBar(
          backgroundColor: Colors.white,
          brightness: Brightness.light,
        ),
      ),
      body: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(15),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Icon(
              FeatherIcons.alertTriangle,
              size: 100,
            ),
            SizedBox(
              height: 25,
            ),
            Text(
              transulate(context, 'error'),
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text(
              transulate(context, 'error_occur'),
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
            SizedBox(
              height: 25,
            ),
            TextButton.icon(
              onPressed: () {},
              label: Text(
                transulate(context, 'retry'),
                style: TextStyle(
                    fontWeight: FontWeight.w600,
                    color: AppColors.secondaryColor),
              ),
              icon: Icon(FeatherIcons.rotateCcw, size: 18),
            ),
          ],
        ),
      ),
    );
  }
}
