import 'package:flutter/material.dart';
import 'package:feather_icons_flutter/feather_icons_flutter.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../../core/common/app_theme.dart';
import '../../../core/localization/transulation_constants.dart';
import '../../../core/models/post_model.dart';
import '../../../core/providers/app_provider.dart';
import '../../../core/utils/tools.dart' as tools;
import '../../options/screen_post_data_options.dart';
import '../../widgets/common/index.dart';
import '../../widgets/posts/screens/favorite_post.dart';
import '../../widgets/posts/screens/floating_post_comments_icon.dart';
import '../../widgets/posts/screens/share_post.dart';
import '../../widgets/tags/index.dart' show TagsList;

class PostScreenThree extends StatelessWidget {
  /// The [post] object to be rendered to this screen
  final Post post;

  PostScreenThree({
    @required this.post,
  });

  /// Widget to render post meta data
  ///
  /// Accept [icon] which describe the data & [value] to be rendered
  Widget _postMetaData({@required IconData icon, @required String value}) {
    return Row(
      children: <Widget>[
        Icon(
          icon,
          size: 14,
          color: Colors.black,
        ),
        SizedBox(
          width: 3,
        ),
        Container(
          margin: const EdgeInsets.only(top: 5),
          child: Text(
            value,
            style: TextStyle(color: Colors.black),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final appScreenOption =
        Provider.of<AppProvider>(context, listen: false).appConfigs.postScreen;
    final screenPostDataOptions =
        ScreenPostDataOptions.fromAppConfig(appScreenOption.options);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          post.category,
        ),
        shape: appBarShape,
        actions: <Widget>[
          if (screenPostDataOptions.showFavoriteOption)
            FavoritePost(
              post: post,
            ),
          if (screenPostDataOptions.showShareOption)
            SharePost(
              post: post,
            ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Container(
              padding: const EdgeInsets.all(15.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Text(
                    post.title,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          if (screenPostDataOptions.showPostCommentsMeta)
                            _postMetaData(
                              icon: FeatherIcons.messageCircle,
                              value: post.comments.toString(),
                            ),
                        ],
                      ),
                      if (screenPostDataOptions.showPostDateMeta)
                        Text(
                          screenPostDataOptions.showDateAsTimeAgo
                              ? formatTimeAgeValue(context, post.createdAt)
                              : DateFormat(screenPostDataOptions.postDateFormat)
                                  .format(post.createdAt),
                          style: TextStyle(color: Colors.black45, fontSize: 14),
                        ),
                    ],
                  ),
                ],
              ),
            ),
            if (post.thumbnail != null)
              tools.cachedImageWidget(src: post.thumbnail, fit: BoxFit.cover),
            Container(
              padding: const EdgeInsets.all(15.0),
              margin: const EdgeInsets.only(
                bottom: 15.0,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  HtmlDetailsData(
                    postContent: post.htmlContent,
                  ),
                  SizedBox(height: 20),
                  if (screenPostDataOptions.showTagsList)
                    TagsList(tags: post.tags),
                  SizedBox(height: 10),
                ],
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: screenPostDataOptions.showCommentsNavigation
          ? FloatingPostCommentsIcon(
              postId: post.id,
              postCommentStatus: post.commentStatus,
              commentsCount: post.comments,
            )
          : null,
    );
  }
}
