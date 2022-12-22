import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../../core/utils/tools.dart' as tools;
import '../../widgets/posts/index.dart' show PostScreenBottomBar;
import '../../widgets/posts/screens/favorite_post.dart';
import '../../widgets/tags/index.dart' show TagsList;
import '../../../core/common/app_color.dart';
import '../../../core/common/app_theme.dart';
import '../../../core/localization/transulation_constants.dart';
import '../../../core/models/post_model.dart';
import '../../../core/providers/app_provider.dart';
import '../../options/screen_post_data_options.dart';
import '../../widgets/common/index.dart';

class PostScreenOne extends StatelessWidget {
  /// The [post] object to be rendered to this screen
  final Post post;

  PostScreenOne({
    @required this.post,
  });

  @override
  Widget build(BuildContext context) {
    final appScreenOption =
        Provider.of<AppProvider>(context, listen: false).appConfigs.postScreen;
    final screenPostDataOptions =
        ScreenPostDataOptions.fromAppConfig(appScreenOption.options);
    return Scaffold(
      body: NestedScrollView(
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return <Widget>[
            SliverAppBar(
              shape: appBarShape,
              expandedHeight: 250.0,
              floating: false,
              pinned: true,
              snap: false,
              elevation: 0,
              flexibleSpace: FlexibleSpaceBar(
                background: Container(
                  foregroundDecoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Colors.transparent,
                        Colors.transparent,
                        Colors.transparent,
                        Colors.black45
                      ],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      stops: [0, 0.1, 0.2, 1],
                    ),
                  ),
                  child: tools.cachedImageWidget(
                      src: post.thumbnail, fit: BoxFit.cover),
                ),
              ),
              actions: <Widget>[
                if (screenPostDataOptions.showFavoriteOption)
                  FavoritePost(
                    post: post,
                  ),
              ],
            ),
          ];
        },
        body: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.all(15.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    if (screenPostDataOptions.showPostCategoryMeta)
                      Container(
                        padding: const EdgeInsets.only(
                          top: 3.0,
                          bottom: 2.0,
                          left: 13.0,
                          right: 13.0,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.secondaryColor,
                          borderRadius: BorderRadius.circular(30),
                        ),
                        child: Text(
                          post.category,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 13.5,
                          ),
                        ),
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
                SizedBox(height: 10),
                Text(
                  post.title,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 10),
                HtmlDetailsData(
                  postContent: post.htmlContent,
                ),
                SizedBox(height: 10),
                if (screenPostDataOptions.showTagsList)
                  TagsList(tags: post.tags),
                SizedBox(height: 10),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: PostScreenBottomBar(
        post: post,
        screenPostDataOptions: screenPostDataOptions,
      ),
    );
  }
}
