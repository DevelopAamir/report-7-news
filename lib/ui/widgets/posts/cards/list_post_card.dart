import 'package:flutter/material.dart';
import 'package:feather_icons_flutter/feather_icons_flutter.dart';
import 'package:intl/intl.dart';
import 'package:report7news/core/utils/tools.dart' as tools
    show cachedImageWidget;
import 'package:provider/provider.dart';
import 'package:tuple/tuple.dart';
import '../../../../core/common/app_color.dart';
import '../../../../core/localization/transulation_constants.dart';
import '../../../../core/models/post_model.dart';
import '../../../../core/providers/app_provider.dart';
import '../../../../core/router.dart';
import '../../../options/card_post_data_options.dart';

class ListPostCard extends StatelessWidget {
  /// The [post] object to be rendered to this card
  final Post post;

  /// Empty space to inscribe inside the container containing the card
  final EdgeInsets padding;

  /// Empty space to surround the container containing the card
  final EdgeInsets margin;

  /// The width of the post thumbnail applied to this list card
  ///
  /// Default value is 80
  final double thumbnailWidth;

  /// The height of the post thumbnail applied to this list card
  ///
  /// Default value is 80
  final double thumbnailHeight;

  /// An optional maximum number of lines for the text to span, wrapping if necessary.
  /// If the text exceeds the given number of lines, it will be truncated.
  ///
  /// Default value is set to 2
  final int titleMaxLines;

  /// Control the post data options for this card
  final CardPostDataOptions cardPostDataOptions;

  ListPostCard({
    @required this.post,
    this.padding,
    this.margin,
    this.thumbnailWidth = 80,
    this.thumbnailHeight = 80,
    this.titleMaxLines,
    this.cardPostDataOptions = const CardPostDataOptions(),
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
          color: Colors.black54,
        ),
        SizedBox(
          width: 3,
        ),
        Container(
          margin: const EdgeInsets.only(top: 5),
          child: Text(
            value,
            style: TextStyle(color: Colors.black54),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final appScreenOption =
        Provider.of<AppProvider>(context, listen: false).appConfigs.postScreen;
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(
          context,
          AppRoutes.post,
          arguments: Tuple2<String, Post>(appScreenOption.style, post),
        );
      },
      child: Container(
        padding: padding,
        margin: margin,
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: AppColors.listSeparatorColor,
              width: 1,
            ),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              width: thumbnailWidth,
              height: thumbnailHeight,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: tools.cachedImageWidget(
                  src: post.thumbnail,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            SizedBox(
              width: 10,
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Text(
                    post.title,
                    maxLines: titleMaxLines,
                    overflow: titleMaxLines != null
                        ? TextOverflow.ellipsis
                        : TextOverflow.visible,
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 16,
                      color: Colors.black,
                    ),
                  ),
                  if (cardPostDataOptions.showPostCommentsMeta)
                    Container(
                      padding: const EdgeInsets.symmetric(
                        vertical: 2,
                      ),
                      child: _postMetaData(
                        icon: FeatherIcons.messageCircle,
                        value: post.comments.toString(),
                      ),
                    ),
                  SizedBox(
                    height: 8,
                  ),
                  if (cardPostDataOptions.showPostExcerpt)
                    Container(
                      margin: const EdgeInsets.only(bottom: 8),
                      child: Text(
                        post.excerpt,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.start,
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.black54,
                        ),
                      ),
                    ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      if (cardPostDataOptions.showPostCategoryMeta)
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
                      if (cardPostDataOptions.showPostDateMeta)
                        Text(
                          cardPostDataOptions.showDateAsTimeAgo
                              ? formatTimeAgeValue(context, post.createdAt)
                              : DateFormat(cardPostDataOptions.postDateFormat)
                                  .format(post.createdAt),
                          style: TextStyle(color: Colors.black45, fontSize: 14),
                        ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
