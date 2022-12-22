import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import '../../../core/constants/config.dart' as config show postsPerPage;
import '../../../core/enums/ui_enums.dart';
import '../../../core/models/category_model.dart';
import '../../../core/models/post_model.dart';
import '../../../core/providers/app_provider.dart';
import '../../../core/repositories/post_repository.dart';
import '../../../core/utils/api_response.dart';
import '../../../core/utils/ui_helper.dart' as uiHelper
    show presentToast, smartRefresherFooter;
import '../../../core/utils/view_data_model.dart';
import '../../../ui/screens/categories/index.dart' show SortScreen;
import '../../../ui/widgets/common/refresher_data_results.dart';
import '../../../ui/widgets/posts/index.dart' show PostsList;
import '../../../core/common/app_theme.dart';

class CategoryScreen extends StatefulWidget {
  final Category category;

  CategoryScreen({@required this.category});

  @override
  _CategoryScreenState createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> {
  final RefreshController _refreshController =
      RefreshController(initialRefresh: true);
  final PostRepository _postRepository = PostRepository();

  ViewDataModel<Post> _postsViewData = ViewDataModel<Post>(data: []);

  SortPostsOption _selectedSortOption;
  String _sortQueryParams = '';

  /// Request posts of the viewed category
  Future<void> _loadCategoryPosts() async {
    _postsViewData.errorMessage = null;
    _postsViewData..isEnd = false;
    ApiResponse<List<Post>> _res = await _postRepository.getPosts(
      query:
          '?categories=${widget.category.id}&per_page=${config.postsPerPage}&page=${_postsViewData.page}$_sortQueryParams',
    );

    if (!_res.error) {
      if (_res.data.isNotEmpty) {
        _postsViewData.data = _postsViewData.data..addAll(_res.data);
      } else {
        _postsViewData.isEnd = true;
      }
    } else {
      _postsViewData.errorMessage = _res.message;
      if (_res.code == 'rest_post_invalid_page_number' ||
          _postsViewData.isInitRequestError()) _postsViewData.isEnd = true;
      if (_postsViewData.page != 1 &&
          _postsViewData.errorMessage != null &&
          _res.code != 'rest_post_invalid_page_number') {
        uiHelper.presentToast(
          message: _postsViewData.errorMessage,
          success: false,
        );
        _postsViewData.page--;
      }
    }
    if (mounted) setState(() {});
  }

  /// Reset paginations of the posts list
  Future<void> _onRefresh() async {
    _postsViewData.page = 1;
    _postsViewData.data = [];
    await _loadCategoryPosts();
    _refreshController.refreshCompleted();
  }

  /// Load more posts to list
  void _onLoading() async {
    _postsViewData.page += 1;
    await _loadCategoryPosts();
    _refreshController.loadComplete();
  }

  /// Method to handle sort posts
  ///
  /// It will show a modal bottom sheet that will render sort screen
  /// Accept [context] to be passd to bottom sheet (Can be remove incase of stateful widget)
  void _openSortOptionsSheet(BuildContext context) {
    showModalBottomSheet<SortPostsOption>(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
      builder: (BuildContext context) =>
          SortScreen(selectedSortOption: _selectedSortOption),
    ).then((SortPostsOption sortOption) async {
      if (sortOption != null) {
        _selectedSortOption =
            sortOption == SortPostsOption.reset ? null : sortOption;
        switch (sortOption) {
          case SortPostsOption.latest:
            _sortQueryParams = '&orderby=date&order=desc';
            break;
          case SortPostsOption.oldest:
            _sortQueryParams = '&orderby=date&order=asc';
            break;
          case SortPostsOption.mostComments:
            _sortQueryParams = '&orderby=comment_count&order=desc';
            break;
          case SortPostsOption.reset:
            _sortQueryParams = '';
            break;
        }
        _refreshController.requestRefresh();
      }
    });
  }

  PostsListType postsListStyle() {
    final appScreenOption = Provider.of<AppProvider>(context, listen: false)
        .appConfigs
        .postsListScreen;
    switch (appScreenOption.style) {
      case 'style1':
        return PostsListType.cardStyleList;
      case 'style2':
        return PostsListType.cardTypeTwoStyleList;
      case 'style3':
        return PostsListType.verticalList;
      default:
        return PostsListType.cardStyleList;
    }
  }

  @override
  Widget build(BuildContext context) {
    final selectedStyle = postsListStyle();
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.category.title),
        shape: appBarShape,
        actions: <Widget>[
          Stack(
            alignment: Alignment.center,
            children: [
              IconButton(
                icon: Icon(Icons.sort),
                onPressed: () => _openSortOptionsSheet(context),
              ),
              if (_selectedSortOption != null)
                Positioned(
                  right: 10,
                  top: 15,
                  child: Container(
                    width: 10,
                    height: 10,
                    decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
      body: SmartRefresher(
        controller: _refreshController,
        enablePullDown: true,
        enablePullUp: !_postsViewData.isEnd,
        onRefresh: () => _onRefresh(),
        onLoading: _onLoading,
        footer: uiHelper.smartRefresherFooter(),
        header: MaterialClassicHeader(),
        child: RefresherDataResults<Post>(
          controller: _refreshController,
          viewDataModel: _postsViewData,
          results: PostsList(
            posts: _postsViewData.data,
            padding: selectedStyle == PostsListType.cardStyleList
                ? const EdgeInsets.all(15)
                : null,
            listType: selectedStyle,
          ),
        ),
      ),
      bottomNavigationBar: Container(

      ),
    );
  }
}
