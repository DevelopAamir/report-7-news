import 'package:flutter/material.dart';
import 'package:feather_icons_flutter/feather_icons_flutter.dart';
import 'package:provider/provider.dart';
import 'package:tuple/tuple.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../core/common/app_theme.dart';
import '../../../core/localization/transulation_constants.dart';
import '../../../core/providers/app_provider.dart';
import '../../../core/router.dart';
import '../../widgets/common/index.dart';

class SettingsScreen extends StatelessWidget {

  Future<void> _openURL(String url) async {
    if (url != null && url.isNotEmpty) {
      await launch(
        url,
        enableJavaScript: true,
        forceSafariVC: true,
        forceWebView: true,
      );
    }
  }

  /// Widget to render head title of the list tile
  ///
  /// Accept [title] which describe the title of the list
  Widget _listHeadTitle(String title) {
    return Container(
      margin: const EdgeInsets.only(
        bottom: 10,
        top: 15,
      ),
      child: Text(
        title,
        style: TextStyle(
          fontWeight: FontWeight.w700,
          fontSize: 20,
        ),
      ),
    );
  }

  /// Widget to render list tile item
  ///
  /// Accept [title] to be presented to list tile
  /// Accept [icon] as leading icon before the title
  /// Accept [showDetailsArrow] control the arrow on the end of the list tile item
  /// Accept [onTap] as a callback function that is called when the user taps this list tile
  Widget _listTileItem({
    @required String title,
    @required IconData icon,
    bool showDetailsArrow = true,
    Function onTap,
  }) {
    return ListTile(
      contentPadding: const EdgeInsets.all(0),
      title: Text(
        title,
        style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
      ),
      leading: Icon(
        icon,
        size: 20,
      ),
      trailing: showDetailsArrow ? Icon(Icons.chevron_right) : null,
      onTap: onTap,
    );
  }

  @override
  Widget build(BuildContext context) {
    final _appScreenOption = Provider.of<AppProvider>(context, listen: false)
        .appConfigs
        .settingsScreen;
    final _pages = _appScreenOption.pages;
    final _contactChannels = _appScreenOption.contactChannels;

    return Scaffold(
      appBar: AppBar(
        title: Text(transulate(context, 'settings')),
        shape: appBarShape,
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              _listHeadTitle(transulate(context, 'app_settings')),
              ...ListTile.divideTiles(context: context, tiles: [
                NotificationsSetting(),
              ]).toList(),
              _listHeadTitle(transulate(context, 'help')),
              ...ListTile.divideTiles(context: context, tiles: [
                _listTileItem(
                  title: transulate(context, 'contact_screen'),
                  icon: FeatherIcons.mail,
                  onTap: () {
                    Navigator.pushNamed(context, AppRoutes.contact);
                  },
                ),
                if (_pages['faq_page'] != null)
                  _listTileItem(
                    title: transulate(context, 'faq_screen'),
                    icon: FeatherIcons.helpCircle,
                    onTap: () {
                      Navigator.pushNamed(
                        context,
                        AppRoutes.page,
                        arguments: Tuple2<int, String>(
                          _pages['faq_page'],
                          transulate(context, 'faq_screen'),
                        ),
                      );
                    },
                  ),
              ]).toList(),
              Builder(
                builder: (_) {
                  if (_appScreenOption.hasNoContactChannels()) return SizedBox();
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      _listHeadTitle(transulate(context, 'contact_channels')),
                      ...ListTile.divideTiles(context: context, tiles: [
                        if (_contactChannels['official_website'] != null &&
                            _contactChannels['official_website'].isNotEmpty)
                          _listTileItem(
                            title: transulate(context, 'officail_website'),
                            icon: FeatherIcons.globe,
                            onTap: () =>
                                _openURL(_contactChannels['official_website']),
                          ),
                        if (_contactChannels['instagram'] != null &&
                            _contactChannels['instagram'].isNotEmpty)
                          _listTileItem(
                            title: transulate(context, 'instagram'),
                            icon: FeatherIcons.instagram,
                            onTap: () =>
                                _openURL(_contactChannels['instagram']),
                          ),
                        if (_contactChannels['facebook'] != null &&
                            _contactChannels['facebook'].isNotEmpty)
                          _listTileItem(
                            title: transulate(context, 'facebook'),
                            icon: FeatherIcons.facebook,
                            onTap: () => _openURL(_contactChannels['facebook']),
                          ),
                        if (_contactChannels['twitter'] != null &&
                            _contactChannels['twitter'].isNotEmpty)
                          _listTileItem(
                            title: transulate(context, 'twitter'),
                            icon: FeatherIcons.twitter,
                            onTap: () => _openURL(_contactChannels['twitter']),
                          ),
                      ]).toList(),
                    ],
                  );
                },
              ),
              Builder(
                builder: (_) {
                  if (_pages['privacy_policy'] == null &&
                      _pages['terms_conditions'] == null) return SizedBox();
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      _listHeadTitle(transulate(context, 'about_app')),
                      ...ListTile.divideTiles(context: context, tiles: [
                        if (_pages['privacy_policy'] != null)
                          _listTileItem(
                            title: transulate(context, 'privacy_policy'),
                            icon: FeatherIcons.fileText,
                            onTap: () {
                              Navigator.pushNamed(
                                context,
                                AppRoutes.page,
                                arguments: Tuple2<int, String>(
                                  _pages['privacy_policy'],
                                  transulate(context, 'privacy_policy'),
                                ),
                              );
                            },
                          ),
                        if (_pages['terms_conditions'] != null)
                          _listTileItem(
                            title: transulate(context, 'terms_conditions'),
                            icon: FeatherIcons.fileText,
                            onTap: () {
                              Navigator.pushNamed(
                                context,
                                AppRoutes.page,
                                arguments: Tuple2<int, String>(
                                  _pages['terms_conditions'],
                                  transulate(context, 'terms_conditions'),
                                ),
                              );
                            },
                          ),
                      ]).toList(),
                    ],
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
