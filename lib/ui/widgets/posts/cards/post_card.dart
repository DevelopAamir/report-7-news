import 'package:feather_icons_flutter/feather_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:tuple/tuple.dart';
import '../../../../core/common/app_color.dart';
import '../../../../core/localization/transulation_constants.dart';
import '../../../../core/models/post_model.dart';
import '../../../../core/providers/app_provider.dart';
import '../../../../core/router.dart';
import '../../../options/card_post_data_options.dart';
import '../../../../core/utils/tools.dart' as tools show cachedImageWidget;

class PostCard extends StatelessWidget {
  /// The [post] object to be rendered to this card
  final Post post;

  /// Empty space to inscribe inside the container containing the card
  final EdgeInsets padding;

  /// Empty space to surround the container containing the card
  final EdgeInsets margin;

  /// Determine whether to apply [boxShadow] to the card or not
  ///
  /// Default value is set to true
  final bool boxShadow;

  /// The [cardRadius] applied to this card
  final double cardRadius;

  /// An optional maximum number of lines for the text to span, wrapping if necessary.
  /// If the text exceeds the given number of lines, it will be truncated.
  ///
  /// Default value is set to 2
  final int titleMaxLines;

  /// A [border] to draw above the card
  final BoxBorder border;

  /// Control the post data options for this card
  final CardPostDataOptions cardPostDataOptions;

  PostCard({
    @required this.post,
    this.padding,
    this.margin,
    this.boxShadow = true,
    this.cardRadius = 15.0,
    this.titleMaxLines,
    this.border,
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
    final double screenWidth = MediaQuery.of(context).size.width;
    final double cardWidth = screenWidth < 320 ? screenWidth : 320;

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
        width: cardWidth,
        padding: padding,
        margin: margin,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(cardRadius),
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: boxShadow ? Color(0xFFf2f2f2) : Colors.transparent,
              blurRadius: 2.0,
              spreadRadius: 2.0,
            ),
          ],
          border: border,
        ),
        child: Column(
          children: <Widget>[
            Stack(
              children: <Widget>[
                Container(
                  width: double.infinity,
                  height: cardWidth * 0.55,
                  child: ClipRRect(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(cardRadius),
                      topRight: Radius.circular(cardRadius),
                    ),
                    child: tools.cachedImageWidget(
                      src: post.thumbnail,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                if (cardPostDataOptions.showPostCommentsMeta)
                  Positioned(
                    top: 20,
                    right: 20,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        vertical: 2,
                        horizontal: 13,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.accentColor,
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: _postMetaData(
                        icon: FeatherIcons.messageCircle,
                        value: post.comments.toString(),
                      ),
                    ),
                  ),
              ],
            ),
            Container(
              padding: const EdgeInsets.all(15),
              width: double.infinity,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
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
