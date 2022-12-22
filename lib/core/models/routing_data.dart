import 'app_model.dart' show AppDrawerItem;

class RoutingData {
  String module;
  String label;
  String value;

  RoutingData({this.module, this.label, this.value});

  RoutingData.fromDrawerItem(AppDrawerItem drawerItem) {
    module = _moduleToRoute(drawerItem.module);
    label = drawerItem.label;
    value = drawerItem.value;
  }

  RoutingData.fromNotificationAdditionalData(Map<String, dynamic> notificationData) {
    module = _moduleToRoute(notificationData['module']);
    label = notificationData['label'].toString();
    value = notificationData['value'].toString();
  }

  String _moduleToRoute(String module){
    List<String> _nonRoutes = ['external'];
    return _nonRoutes.contains(module) ? module : '/$module';
  }

  @override
  String toString() {
    return 'Module: $module - Label: $label - Value: $value';
  }
}
