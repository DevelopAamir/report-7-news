import 'package:feather_icons_flutter/feather_icons_flutter.dart';
import 'package:flutter/material.dart';
import '../../../core/common/app_color.dart';
import '../../../core/localization/transulation_constants.dart';
import '../../../core/services/localstorage_service.dart';

class NotificationsSetting extends StatefulWidget {
  @override
  NotificationsSettingState createState() => NotificationsSettingState();
}

class NotificationsSettingState extends State<NotificationsSetting> {
  final String _storageKey = 'notification_setting';
  final LocalStorageService _storageService = LocalStorageService();

  /// Notification permission control
  bool _allowNotification = true;

  @override
  void initState() {
    _getSettingValue();
    super.initState();
  }

  Future<void> _getSettingValue() async {
    try{
      final _res = await _storageService.getFromStorage(_storageKey);
      _allowNotification = _res != null ? _res as bool : true;
    }catch(e){
      print(e);
      _allowNotification = true;
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return SwitchListTile(
      contentPadding: const EdgeInsets.all(0),
      activeColor: AppColors.secondaryColor,
      title: Text(
        transulate(context, 'receive_notifications'),
        style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
      ),
      secondary: Icon(
        FeatherIcons.bell,
        size: 20,
      ),
      value: _allowNotification,
      onChanged: (value) async {
        try{
          await _storageService.saveToStorage<bool>(_storageKey, !_allowNotification);
        }catch(e){
          print(e);
        }

      },
    );
  }
}
