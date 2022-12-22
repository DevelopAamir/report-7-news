import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/common/app_color.dart';
import '../../../core/enums/core_enums.dart';
import '../../../core/models/app_model.dart' show AppDrawerItem;
import '../../../core/providers/app_provider.dart';
import '../../../core/services/routing_service.dart';

class AppDrawer extends StatelessWidget {
  /// Widget to render list tile item
  ///
  /// Accept [title] to be presented to list tile
  /// Accept [icon] as leading icon before the title
  /// Accept [showDetailsArrow] control the arrow on the end of the list tile item
  /// Accept [onTap] as a callback function that is called when the user taps this list tile
  Widget _listTileItem({
    @required String title,
    bool showDetailsArrow = true,
    Function onTap,
  }) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 15),
      title: Text(
        title,
        style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
      ),
      trailing: showDetailsArrow ? Icon(Icons.chevron_right) : null,
      onTap: onTap,
    );
  }

  void _navigate({
    @required AppDrawerItem item,
    @required BuildContext context,
  }) {
    RoutingService.of(context).navigate<AppDrawerItem>(
      scheme: RoutingScheme.drawer,
      data: item,
    );
  }

  @override
  Widget build(BuildContext context) {
    final _appGeneralOption = Provider.of<AppProvider>(context, listen: false)
        .appConfigs
        .appGeneralOption;
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            child: Container(),
            decoration: BoxDecoration(
              color: AppColors.primaryColor,
            ),
          ),
          if (_appGeneralOption != null &&
              _appGeneralOption.drawerItems != null)
            Column(
              children: _appGeneralOption.drawerItems.map((item) {
                return _listTileItem(
                  title: item.label,
                  onTap: () => _navigate(context: context, item: item),
                );
              }).toList(),
            ),
        ],
      ),
    );
  }
}
