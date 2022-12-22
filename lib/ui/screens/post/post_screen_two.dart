import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/common/app_theme.dart';
import '../../../core/models/post_model.dart';
import '../../../core/providers/app_provider.dart';
import '../../../core/utils/tools.dart' as tools;
import '../../options/screen_post_data_options.dart';
import '../../widgets/common/index.dart';
import '../../widgets/posts/index.dart' show PostScreenTopBar;
import '../../widgets/posts/screens/favorite_post.dart';
import '../../widgets/posts/screens/floating_post_comments_icon.dart';
import '../../widgets/posts/screens/share_post.dart';
import '../../widgets/tags/index.dart' show TagsList;

class PostScreenTwo extends StatelessWidget {
  /// The [post] object to be rendered to this screen
  final Post post;

  PostScreenTwo({
    @required this.post,
  });

  @override
  Widget build(BuildContext context) {
    final appScreenOption =
        Provider.of<AppProvider>(context, listen: false).appConfigs.postScreen;
    final screenPostDataOptions =
        ScreenPostDataOptions.fromAppConfig(appScreenOption.options);
    return Scaffold(
      appBar: AppBar(
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
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          PostScreenTopBar(
            post: post,
            screenPostDataOptions: screenPostDataOptions,
          ),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  if (post.thumbnail != null)
                    tools.cachedImageWidget(
                        src: post.thumbnail, fit: BoxFit.cover),
                  Container(
                    padding: const EdgeInsets.all(15.0),
                    margin: const EdgeInsets.only(
                      bottom: 15.0,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: <Widget>[
                        Text(
                          post.title,
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
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
          ),
        ],
      ),
      floatingActionButton: FloatingPostCommentsIcon(
        postId: post.id,
        postCommentStatus: post.commentStatus,
        commentsCount: post.comments,
      ),
    );
  }
}
