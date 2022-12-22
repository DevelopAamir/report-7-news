import 'package:flutter/material.dart';
import '../../../../core/common/app_color.dart';
import '../../../../core/enums/ui_enums.dart';
import '../../../../core/localization/transulation_constants.dart';
import '../../../../core/models/category_model.dart';
import '../../../../core/utils/tools.dart' as tools show cachedImageWidget;
import '../../../options/card_category_data_options.dart';

class CategoryListCard extends StatelessWidget {
  /// The [category] object to be rendered to this card
  final Category category;

  /// Empty space to inscribe inside the container containing the card
  final EdgeInsets padding;

  /// Empty space to surround the container containing the card
  final EdgeInsets margin;

  /// The width of the category image applied to this list card
  ///
  /// Default value is 80
  final double imageWidth;

  /// The height of the category image applied to this list card
  ///
  /// Default value is 80
  final double imageHeight;

  /// Determine whether to show category image to the side of this card or not
  ///
  /// Default value is set to false
  final bool showCategoryImage;

  /// Control the post data options for this card
  final CardCategoryDataOptions cardCategoryDataOptions;

  CategoryListCard({
    @required this.category,
    this.padding,
    this.margin,
    this.imageWidth = 80,
    this.imageHeight = 80,
    this.showCategoryImage = false,
    this.cardCategoryDataOptions = const CardCategoryDataOptions(),
  });

  @override
  Widget build(BuildContext context) {
    return Container(
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
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          if (showCategoryImage)
            Container(
              width: imageWidth,
              height: imageHeight,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: tools.cachedImageWidget(
                  src: category.image,
                  fit: BoxFit.cover,
                ),
              ),
            ),
          if (showCategoryImage)
            SizedBox(
              width: 10,
            ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                if (cardCategoryDataOptions.showCategoryTitle && category.title != null && category.title.isNotEmpty)
                  Container(
                    margin: const EdgeInsets.only(bottom: 3),
                    child: Text(
                      category.title,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                        color: Colors.black,
                      ),
                    ),
                  ),
                if (cardCategoryDataOptions.showCategorySubtitle && category.subtitle != null && category.subtitle.isNotEmpty)
                  Container(
                    margin: const EdgeInsets.only(bottom: 6),
                    child: Text(
                      category.subtitle,
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 14,
                        color: Colors.black,
                      ),
                    ),
                  ),
                if (cardCategoryDataOptions.showCategoryPostsCount &&
                    cardCategoryDataOptions.categoryPostsCountStyle ==
                        CategoryPostsCountStyle.labelStyle && category.postsCount != null)
                  Text(
                    transulate(context, 'total_posts:') +
                        category.postsCount.toString(),
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 14,
                    ),
                  ),
              ],
            ),
          ),
          if (cardCategoryDataOptions.showCategoryPostsCount && [CategoryPostsCountStyle.circleBadge, CategoryPostsCountStyle.sequareBadge].contains(cardCategoryDataOptions.categoryPostsCountStyle) && category.postsCount != null)
          Container(
            width: 40,
            height: 40,
            padding: const EdgeInsets.only(top: 5),
            decoration: BoxDecoration(
              color: AppColors.accentColor,
              borderRadius: cardCategoryDataOptions.categoryPostsCountStyle ==
                      CategoryPostsCountStyle.circleBadge
                  ? BorderRadius.circular(30)
                  : null,
            ),
            child: Center(
              child: Text(
                category.postsCount.toString(),
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
