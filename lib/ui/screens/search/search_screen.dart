import 'package:flutter/material.dart';
import '../../../core/common/app_color.dart';
import '../../../core/common/app_theme.dart' show appBarShape;
import '../../../core/localization/transulation_constants.dart';
import '../../../core/repositories/search_history_repository.dart';
import '../../../core/router.dart';
import '../../widgets/common/error_message.dart';
import '../../widgets/search/index.dart';

class SearchScreen extends StatelessWidget {
  final TextEditingController _searchController = TextEditingController();
  final SearchHistoryRepository _searchHistoryRepository =
      SearchHistoryRepository();

  final ValueNotifier<List<String>> _searchHistoryNotifier =
      ValueNotifier<List<String>>([]);

  void _onSearch(String query, BuildContext context) {
    if (query == null || query.isEmpty) return;
    if (!_searchHistoryNotifier.value.contains(query)) {
      _searchHistoryRepository.addToSearchHistories(query);
      _searchHistoryNotifier.value = []
        ..addAll(_searchHistoryNotifier.value)
        ..insert(0, query);
    }
    Navigator.pushNamed(
      context,
      AppRoutes.searchResults,
      arguments: query,
    );
  }

  Future<void> _onRemoveHistoryItem(int index) async {
    _searchHistoryNotifier.value = []
      ..addAll(_searchHistoryNotifier.value..removeAt(index));
    await _searchHistoryRepository
        .saveSearchHistories(_searchHistoryNotifier.value);
  }

  Widget _renderSearchHistories(BuildContext context) {
    return FutureBuilder(
      future: _searchHistoryRepository.getSearchHistories(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return SizedBox();
        } else {
          if (snapshot.error != null) {
            return ErrorMessage(
              message: transulate(context, 'error_loading_search_history'),
            );
          } else {
            List<String> _response = snapshot.data as List<String>;
            if (_response != null && _response.isNotEmpty) {
              _searchHistoryNotifier.value = _response;
              return ValueListenableBuilder(
                valueListenable: _searchHistoryNotifier,
                builder: (_, List<String> terms, __) {
                  return SearchHistories(
                    history: terms,
                    onSearch: (String query) => _onSearch(query, context),
                    onRemove: _onRemoveHistoryItem,
                  );
                },
              );
            } else {
              return SizedBox();
            }
          }
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.primaryColor,
        title: _SearchAppBar(
          controller: _searchController,
          onSearch: (String value) => _onSearch(value, context),
        ),
        shape: appBarShape,
        actions: [
          ValueListenableBuilder(
            valueListenable: _searchController,
            child: IconButton(
              icon: Icon(
                Icons.clear,
                color: Colors.white,
                size: 20,
              ),
              onPressed: () => _searchController.text = '',
            ),
            builder: (_, TextEditingValue value, Widget child) {
              if (value != null &&
                  value.text != null &&
                  value.text.isNotEmpty) {
                return child;
              }
              return SizedBox();
            },
          ),
        ],
      ),
      body: _renderSearchHistories(context),
    );
  }
}

class _SearchAppBar extends StatelessWidget {
  final ValueChanged<String> onSearch;
  final TextEditingController controller;

  _SearchAppBar({@required this.controller, this.onSearch});

  @override
  Widget build(BuildContext context) {
    final ThemeData _theme = Theme.of(context).copyWith(
      inputDecorationTheme: InputDecorationTheme(
        hintStyle: TextStyle(
          color: Colors.white54,
          fontWeight: FontWeight.normal,
        ),
      ),
      textTheme: TextTheme(
        headline6: TextStyle(
          fontSize: 17,
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
    return TextField(
      controller: controller,
      autofocus: true,
      style: _theme.textTheme.headline6,
      textInputAction: TextInputAction.search,
      keyboardType: TextInputType.text,
      onSubmitted: onSearch,
      decoration: InputDecoration(
        border: InputBorder.none,
        hintText: transulate(context, 'search'),
        hintStyle: TextStyle(
          color: Colors.white54,
          fontWeight: FontWeight.normal,
        ),
      ),
    );
  }
}
