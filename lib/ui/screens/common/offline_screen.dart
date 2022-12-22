import 'package:flutter/material.dart';
import 'package:feather_icons_flutter/feather_icons_flutter.dart';
import '../../../core/localization/transulation_constants.dart';

class OfflineScreen extends StatelessWidget {
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
            Icon(FeatherIcons.wifiOff, size: 100,),
            SizedBox(height: 25,),
            Text(transulate(context, 'no_connection'), style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),),
            SizedBox(height: 10),
            Text(transulate(context, 'check_connection'), style: TextStyle(fontWeight: FontWeight.w600),),
          ],
        ),
      ),
    );
  }
}