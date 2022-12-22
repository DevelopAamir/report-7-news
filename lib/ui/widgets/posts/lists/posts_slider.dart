import 'package:flutter/material.dart';
import '../../../../core/localization/transulation_constants.dart';
import '../../../../core/models/post_model.dart';
import '../../../options/card_post_data_options.dart';
import '../index.dart' show PostCard;

class PostsSlider extends StatelessWidget {
  /// Posts Llist to be rendered with slider
  final List<Post> posts;

  /// Empty space to inscribe inside the container containing the slides
  final EdgeInsets padding;

  /// Empty space to surround the container containing the slides
  final EdgeInsets margin;

  PostsSlider({@required this.posts, this.padding, this.margin});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Container(
        padding: padding,
        margin: margin,
        child: IntrinsicHeight(
          child: Row(
            children: posts
                .map((post) => PostCard(
                      post: post,
                      cardPostDataOptions: CardPostDataOptions(
                        showPostCommentsMeta: false,
                        showPostExcerpt: false,
                      ),
                      margin: EdgeInsets.only(
                        left: isRTL(context) ? 10 : 0.0,
                        right: !isRTL(context) ? 10 : 0.0,
                      ),
                      titleMaxLines: 2,
                    ))
                .toList(),
          ),
        ),
      ),
    );
  }
}
