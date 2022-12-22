import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:feather_icons_flutter/feather_icons_flutter.dart';
import '../../../core/utils/ui_helper.dart' as uiHelper
    show presentToast, smartRefresherFooter;
import '../../../core/utils/view_data_model.dart';
import '../../../ui/widgets/comments/comment_item.dart';
import '../../../ui/widgets/comments/index.dart' show AddNewComment;
import '../../../ui/widgets/common/error_message.dart';
import '../../../ui/widgets/common/no_content.dart';
import '../../../core/common/app_theme.dart';
import '../../../core/localization/transulation_constants.dart';
import '../../../core/models/comment_model.dart';
import '../../../core/providers/app_provider.dart';
import '../../../core/repositories/comment_repository.dart';
import '../../../core/utils/api_response.dart';

class CommentsScreen extends StatefulWidget {
  final int postId;
  final String postCommentStatus;
  final int commentsCount;

  CommentsScreen(
      {@required this.postId,
      @required this.postCommentStatus,
      @required this.commentsCount});

  @override
  _CommentsScreenState createState() => _CommentsScreenState();
}

class _CommentsScreenState extends State<CommentsScreen> {
  final RefreshController _refreshController =
      RefreshController(initialRefresh: true);

  final CommentRepository _commentRepository = CommentRepository();

  ViewDataModel<Comment> _commentsViewData = ViewDataModel<Comment>(data: []);

  /// Request posts of the viewed category
  Future<void> _loadPostComments() async {
    _commentsViewData.errorMessage = null;
    _commentsViewData.isEnd = false;
    ApiResponse<List<Comment>> _res = await _commentRepository.getPostComments(
        postId: widget.postId, page: _commentsViewData.page);
    if (!_res.error) {
      if (_res.data.isNotEmpty) {
        _commentsViewData.data = _commentsViewData.data..addAll(_res.data);
      } else {
        _commentsViewData.isEnd = true;
      }
    } else {
      _commentsViewData.errorMessage = _res.message;
      if (_res.code == 'rest_post_invalid_page_number' ||
          _commentsViewData.isInitRequestError())
        _commentsViewData.isEnd = true;
      if (_commentsViewData.page != 1 &&
          _commentsViewData.errorMessage != null) {
        uiHelper.presentToast(
          message: _commentsViewData.errorMessage,
          success: false,
        );
        _commentsViewData.page--;
      }
    }
    if (mounted) setState(() {});
  }

  /// Reset paginations of the comments list
  Future<void> _onRefresh() async {
    _commentsViewData.page = 1;
    _commentsViewData.data = [];
    await _loadPostComments();
    _refreshController.refreshCompleted();
  }

  /// Load more comments to list
  void _onLoading() async {
    _commentsViewData.page += 1;
    await _loadPostComments();
    _refreshController.loadComplete();
  }

  /// Method to handle add comment icon
  ///
  /// It will show a modal bottom sheet that will render add comment form
  /// Accept [context] to be passd to bottom sheet
  void _addNewComment(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(12),
          topRight: Radius.circular(12),
        ),
      ),
      isScrollControlled: true,
      builder: (BuildContext ctx) {
        return AddNewComment(widget.postId);
      },
    );
  }

  /// Represent response data results
  Widget _dataResults() {
    List<Comment> _comments = _commentsViewData.data;
    if (_commentsViewData.isInitRequestError()) {
      return ErrorMessage(
        message: _commentsViewData.errorMessage,
      );
    } else {
      if (_comments.isEmpty &&
          _refreshController.headerStatus == RefreshStatus.completed) {
        _refreshController.loadNoData();
        return NoContent();
      }
      return ListView.builder(
        itemCount: _comments.length,
        itemBuilder: (BuildContext context, int index) {
          return CommentItem(comment: _comments[index]);
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final _appGeneralOption = Provider.of<AppProvider>(context, listen: false)
        .appConfigs
        .appGeneralOption;
    final bool _isCommentActive = widget.postCommentStatus == 'open' &&
        _appGeneralOption != null &&
        _appGeneralOption.allowComment;
    return Scaffold(
      appBar: AppBar(
        title: Text(
            transulate(context, 'comments') + ' (${widget.commentsCount})'),
        shape: appBarShape,
        actions: <Widget>[
          if (_isCommentActive)
            IconButton(
              icon: Icon(
                FeatherIcons.edit,
                size: 22,
              ),
              onPressed: () => _addNewComment(context),
            ),
        ],
      ),
      body: SmartRefresher(
        controller: _refreshController,
        enablePullDown: true,
        enablePullUp: !_commentsViewData.isEnd,
        onRefresh: () => _onRefresh(),
        onLoading: _onLoading,
        footer: uiHelper.smartRefresherFooter(),
        header: MaterialClassicHeader(),
        child: _dataResults(),
      ),
    );
  }
}
