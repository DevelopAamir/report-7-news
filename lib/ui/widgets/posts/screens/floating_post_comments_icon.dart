import 'package:feather_icons_flutter/feather_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:tuple/tuple.dart';
import '../../../../core/router.dart';

class FloatingPostCommentsIcon extends StatelessWidget {
  final int postId;
  final String postCommentStatus;
  final int commentsCount;

  FloatingPostCommentsIcon({
    @required this.postId,
    @required this.postCommentStatus,
    @required this.commentsCount,
  });

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      elevation: 0,
      onPressed: () {
        Navigator.pushNamed(
          context,
          AppRoutes.comments,
          arguments: Tuple3<int, String, int>(postId, postCommentStatus, commentsCount),
        );
      },
      child: Icon(
        FeatherIcons.messageCircle,
      ),
    );
  }
}
