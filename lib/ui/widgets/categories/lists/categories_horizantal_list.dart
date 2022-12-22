import 'package:flutter/material.dart';
import '../../categories/index.dart'
    show CategoryImageCard;
import '../../../../core/localization/transulation_constants.dart';
import '../../../../core/models/category_model.dart';
import '../../../../core/router.dart';
import '../../../options/card_category_data_options.dart';

class CategoriesHorizantalList extends StatelessWidget {
  final List<Category> categories;

  /// Empty space to inscribe inside the container containing the slides
  final EdgeInsets padding;

  /// Empty space to surround the container containing the slides
  final EdgeInsets margin;

  CategoriesHorizantalList({
    @required this.categories,
    this.padding,
    this.margin,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Container(
        padding: padding,
        margin: margin,
        child: IntrinsicHeight(
          child: Row(
            children: categories
                .map(
                  (category) => GestureDetector(
                    onTap: () {
                      Navigator.pushNamed(
                        context,
                        AppRoutes.category,
                        arguments: category,
                      );
                    },
                    child: CategoryImageCard(
                      category: category,
                      margin: EdgeInsets.only(
                        left: isRTL(context) ? 10 : 0.0,
                        right: !isRTL(context) ? 10 : 0.0,
                      ),
                      width: 260,
                      height: 110,
                      cardCategoryDataOptions: CardCategoryDataOptions(
                        showCategoryPostsCount: false,
                      ),
                    ),
                  ),
                )
                .toList(),
          ),
        ),
      ),
    );
  }
}
