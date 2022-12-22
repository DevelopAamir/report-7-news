import 'package:feather_icons_flutter/feather_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../../core/common/app_theme.dart';
import '../../../../core/localization/transulation_constants.dart';
import '../../../../core/models/post_model.dart';
import '../../../options/screen_post_data_options.dart';

class PostScreenTopBar extends StatelessWidget {
  /// The [post] object to be rendered to this screen
  final Post post;

  /// Control the post data options for this screen
  final ScreenPostDataOptions screenPostDataOptions;

  PostScreenTopBar({
    @required this.post,
    @required this.screenPostDataOptions,
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

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 20,
        vertical: 12,
      ),
      decoration: BoxDecoration(
        border: appBarShape,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              if (screenPostDataOptions.showPostCategoryMeta)
                Text(
                  post.category,
                  style: TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              SizedBox(
                width: 8,
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
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              if (screenPostDataOptions.showPostCommentsMeta)
                _postMetaData(
                  icon: FeatherIcons.messageCircle,
                  value: post.comments.toString(),
                ),
            ],
          ),
        ],
      ),
    );
  }
}
