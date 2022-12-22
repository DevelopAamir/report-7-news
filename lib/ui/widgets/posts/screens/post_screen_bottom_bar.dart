import 'package:feather_icons_flutter/feather_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:tuple/tuple.dart';
import '../../../../core/models/post_model.dart';
import '../../../../core/router.dart';
import '../../../options/screen_post_data_options.dart';
import 'share_post.dart';

class PostScreenBottomBar extends StatelessWidget {
  /// The [post] object to be rendered to this screen
  final Post post;

  /// Control the post data options for this screen
  final ScreenPostDataOptions screenPostDataOptions;

  PostScreenBottomBar({
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
    return BottomAppBar(
      child: Container(
        padding: const EdgeInsets.all(15),
        child: Row(
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
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                if (screenPostDataOptions.showCommentsNavigation)
                  GestureDetector(
                    child: Icon(
                      FeatherIcons.messageCircle,
                      size: 20,
                    ),
                    onTap: () {
                      Navigator.pushNamed(
                        context,
                        AppRoutes.comments,
                        arguments: Tuple3<int, String, int>(post.id, post.commentStatus, post.comments),
                      );
                    },
                  ),
                SizedBox(
                  width: 20,
                ),
                if (screenPostDataOptions.showShareOption)
                  SharePost(
                    post: post,
                    iconSize: 20,
                    isBottomNavigation: true,
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
