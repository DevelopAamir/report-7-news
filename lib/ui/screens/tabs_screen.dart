import 'package:flutter/material.dart';
import 'package:feather_icons_flutter/feather_icons_flutter.dart';
import '../screens/categories/index.dart' show CategoriesList;
import '../screens/search/index.dart' show SearchScreen;
import '../widgets/common/index.dart' show AppDrawer;
import '../../core/localization/transulation_constants.dart';
import 'common/index.dart' show FavoriteScreen, SettingsScreen;
import 'home/home_screen.dart';

class TabsScreen extends StatefulWidget {
  @override
  _TabsScreenState createState() => _TabsScreenState();
}

class _TabsScreenState extends State<TabsScreen> {
  final List<Widget> _pages = [
    HomeScreen(),
    CategoriesList(),
    SearchScreen(),
    FavoriteScreen(),
    SettingsScreen(),
  ];

  int _selectedPageIndex = 0;

  /// Set view page to the selected bottom item
  ///
  /// Accept [index] value of the selected bottom item
  void _selectPage(int index) {
    setState(() {
      _selectedPageIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedPageIndex],
      drawer: AppDrawer(),
      bottomNavigationBar: BottomNavigationBar(
        onTap: _selectPage,
        elevation: 0,
        backgroundColor: Theme.of(context).primaryColor,
        selectedItemColor: Theme.of(context).accentColor,
        unselectedItemColor: Colors.white,
        type: BottomNavigationBarType.fixed,
        currentIndex: _selectedPageIndex,
        unselectedFontSize: 12,
        selectedFontSize: 12,
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Padding(
              padding: const EdgeInsets.only(bottom: 5),
              child: Icon(FeatherIcons.home),
            ),
            label: transulate(context, 'home'),
          ),
          BottomNavigationBarItem(
            icon: Padding(
              padding: const EdgeInsets.only(bottom: 5),
              child: Icon(FeatherIcons.grid),
            ),
            label: transulate(context, 'categories'),
          ),
          BottomNavigationBarItem(
            icon: Padding(
              padding: const EdgeInsets.only(bottom: 5),
              child: Icon(FeatherIcons.search),
            ),
            label: transulate(context, 'search'),
          ),
          BottomNavigationBarItem(
            icon: Padding(
              padding: const EdgeInsets.only(bottom: 5),
              child: Icon(FeatherIcons.heart),
            ),
            label: transulate(context, 'favorite'),
          ),
          BottomNavigationBarItem(
            icon: Padding(
              padding: const EdgeInsets.only(bottom: 5),
              child: Icon(FeatherIcons.settings),
            ),
            label: transulate(context, 'settings'),
          ),
        ],
      ),
    );
  }
}
