import 'package:flutter/material.dart';
import '../../../../core/common/app_color.dart';
import '../../../../core/enums/ui_enums.dart';
import '../../../../core/localization/transulation_constants.dart';
import '../../../../core/models/category_model.dart';
import '../../../options/card_category_data_options.dart';

class CategoryColoredCard extends StatelessWidget {
  /// The [category] object to be rendered to this card
  final Category category;

  /// Empty space to inscribe inside the container containing the card
  final EdgeInsets padding;

  /// Empty space to surround the container containing the card
  final EdgeInsets margin;

  /// Represents the width of this card
  final double width;

  /// Represents the height of this card
  final double height;

  /// The [cardRadius] applied to this card
  ///
  /// Default value is 10
  final double cardRadius;

  /// Control the post data options for this card
  final CardCategoryDataOptions cardCategoryDataOptions;

  CategoryColoredCard({
    @required this.category,
    this.padding,
    this.margin,
    this.width,
    this.height,
    this.cardRadius = 10,
    this.cardCategoryDataOptions = const CardCategoryDataOptions(),
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding,
      margin: margin,
      width: width,
      height: height,
      child: Stack(
        children: <Widget>[
          Container(
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
              borderRadius: BorderRadius.circular(cardRadius),
            ),
            decoration: BoxDecoration(
              color: category.cardColor,
              borderRadius: BorderRadius.circular(cardRadius),
            ),
          ),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(15),
            child: Stack(
              children: <Widget>[
                if (cardCategoryDataOptions.showCategoryPostsCount && [CategoryPostsCountStyle.circleBadge, CategoryPostsCountStyle.sequareBadge].contains(cardCategoryDataOptions.categoryPostsCountStyle) && category.postsCount != null)
                  Positioned(
                    left: 0,
                    child: Container(
                      width: 40,
                      height: 40,
                      padding: const EdgeInsets.only(top: 5),
                      decoration: BoxDecoration(
                        color: AppColors.accentColor,
                        borderRadius: cardCategoryDataOptions.categoryPostsCountStyle == CategoryPostsCountStyle.circleBadge ? BorderRadius.circular(30) : null,
                      ),
                      child: Center(
                        child: Text(
                          category.postsCount.toString(),
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    if (cardCategoryDataOptions.showCategoryTitle && category.title != null && category.title.isNotEmpty)
                      Container(
                        margin: const EdgeInsets.only(bottom: 4),
                        child: Text(
                          category.title,
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w700,
                            fontSize: 20,
                          ),
                        ),
                      ),
                    if (cardCategoryDataOptions.showCategorySubtitle && category.subtitle != null && category.subtitle.isNotEmpty)
                      Container(
                        margin: const EdgeInsets.only(bottom: 6),
                        child: Text(
                          category.subtitle,
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                            fontSize: 15,
                          ),
                        ),
                      ),
                    if (cardCategoryDataOptions.showCategoryPostsCount &&
                        cardCategoryDataOptions.categoryPostsCountStyle ==
                            CategoryPostsCountStyle.labelStyle && category.postsCount != null)
                      Text(
                        transulate(context, 'total_posts:')+category.postsCount.toString(),
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                        ),
                      ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
