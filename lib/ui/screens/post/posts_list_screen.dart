import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import '../../../core/constants/config.dart' as config show postsPerPage;
import '../../../core/enums/ui_enums.dart';
import '../../../core/models/post_model.dart';
import '../../../core/providers/app_provider.dart';
import '../../../core/repositories/post_repository.dart';
import '../../../core/utils/api_response.dart';
import '../../../core/utils/ui_helper.dart' as uiHelper
    show presentToast, smartRefresherFooter;
import '../../../core/utils/view_data_model.dart';
import '../../widgets/common/refresher_data_results.dart';
import '../../widgets/posts/index.dart' show PostsList;
import '../../../core/common/app_theme.dart';

class PostsListScreen extends StatefulWidget {
  final String title;
  final String query;

  PostsListScreen({@required this.title, this.query});

  @override
  _PostsListScreenState createState() => _PostsListScreenState();
}

class _PostsListScreenState extends State<PostsListScreen> {
  final RefreshController _refreshController =
      RefreshController(initialRefresh: true);
  final PostRepository _postRepository = PostRepository();

  ViewDataModel<Post> _postsViewData = ViewDataModel<Post>(data: []);

  /// Request posts of the viewed category
  Future<void> _loadCategoryPosts() async {
    _postsViewData.errorMessage = null;
    _postsViewData..isEnd = false;
    ApiResponse<List<Post>> _res = await _postRepository.getPosts(
      query:
          '?per_page=${config.postsPerPage}&page=${_postsViewData.page}${widget.query ?? ""}',
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
        title: Text(widget.title),
        shape: appBarShape,
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
    );
  }
}
