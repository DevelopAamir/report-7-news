import 'package:feather_icons_flutter/feather_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:share/share.dart';
import '../../../../core/models/post_model.dart';

class SharePost extends StatelessWidget {
  final Post post;
  final double iconSize;
  final bool isBottomNavigation;
  SharePost({@required this.post, this.iconSize, this.isBottomNavigation = false});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      padding: EdgeInsets.zero,
      constraints: isBottomNavigation ? BoxConstraints() : null,
      icon: Icon(
        FeatherIcons.share,
        size: iconSize,
      ),
      onPressed: () async {
        String _text = post.title + '\n' + post.link;
        await Share.share(_text, subject: post.title);
      },
    );
  }
}
