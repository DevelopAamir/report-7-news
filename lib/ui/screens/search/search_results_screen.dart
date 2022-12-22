import 'package:flutter/material.dart';
import 'package:report7news/core/localization/transulation_constants.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import '../../../core/enums/ui_enums.dart';
import '../../../core/utils/ui_helper.dart' as uiHelper
    show presentToast, smartRefresherFooter;
import '../../../core/common/app_theme.dart';
import '../../../core/models/post_model.dart';
import '../../../core/repositories/post_repository.dart';
import '../../../core/utils/api_response.dart';
import '../../../core/utils/view_data_model.dart';
import '../../widgets/common/refresher_data_results.dart';
import '../../widgets/posts/index.dart' show PostsList;

class SearchResultsScreen extends StatefulWidget {
  final String searchQuery;
  SearchResultsScreen({@required this.searchQuery});

  @override
  _SearchResultsScreenState createState() => _SearchResultsScreenState();
}

class _SearchResultsScreenState extends State<SearchResultsScreen> {
  /// Represents the style of the list to be rendered
  ///
  /// Default selected style is cardStyleList
  final PostsListType selectedStyle = PostsListType.cardStyleList;

  final RefreshController _refreshController =
      RefreshController(initialRefresh: true);
  final PostRepository _postRepository = PostRepository();

  ViewDataModel<Post> _searchResultsViewData = ViewDataModel<Post>(data: []);

  /// Request search results
  Future<void> _loadPostsResults() async {
    _searchResultsViewData.errorMessage = null;
    _searchResultsViewData..isEnd = false;
    ApiResponse<List<Post>> _res = await _postRepository.searchPosts(
      searchQuery: widget.searchQuery,
      page: _searchResultsViewData.page,
    );

    if (!_res.error) {
      if (_res.data.isNotEmpty) {
        _searchResultsViewData.data = _searchResultsViewData.data
          ..addAll(_res.data);
      } else {
        _searchResultsViewData.isEnd = true;
      }
    } else {
      _searchResultsViewData.errorMessage = _res.message;
      if (_res.code == 'rest_post_invalid_page_number' ||
          _searchResultsViewData.isInitRequestError())
        _searchResultsViewData.isEnd = true;
      if (_searchResultsViewData.page != 1 &&
          _searchResultsViewData.errorMessage != null &&
          _res.code != 'rest_post_invalid_page_number') {
        uiHelper.presentToast(
          message: _searchResultsViewData.errorMessage,
          success: false,
        );
        _searchResultsViewData.page--;
      }
    }
    if (mounted) setState(() {});
  }

  /// Reset paginations of the posts list
  Future<void> _onRefresh() async {
    _searchResultsViewData.page = 1;
    _searchResultsViewData.data = [];
    await _loadPostsResults();
    _refreshController.refreshCompleted();
  }

  /// Load more posts to list
  void _onLoading() async {
    _searchResultsViewData.page += 1;
    await _loadPostsResults();
    _refreshController.loadComplete();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(transulate(context, 'search') + ': ' + widget.searchQuery),
        shape: appBarShape,
      ),
      body: SmartRefresher(
        controller: _refreshController,
        enablePullDown: true,
        enablePullUp: !_searchResultsViewData.isEnd,
        onRefresh: () => _onRefresh(),
        onLoading: _onLoading,
        footer: uiHelper.smartRefresherFooter(),
        header: MaterialClassicHeader(),
        child: RefresherDataResults<Post>(
          controller: _refreshController,
          viewDataModel: _searchResultsViewData,
          results: PostsList(
            posts: _searchResultsViewData.data,
            padding: selectedStyle == PostsListType.cardStyleList
                ? const EdgeInsets.all(15)
                : null,
            listType: selectedStyle,
          ),
        ),
      ),
    );
  }
}
