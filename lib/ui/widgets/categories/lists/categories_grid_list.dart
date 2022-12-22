import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/enums/ui_enums.dart';
import '../../../../core/models/category_model.dart';
import '../../../../core/providers/app_provider.dart';
import '../../../../core/router.dart';
import '../../../options/card_category_data_options.dart';
import '../index.dart' show CategoryColoredCard, CategoryImageCard;

class CategoriesGridList extends StatelessWidget {
  /// Categories List to be rendered
  final List<Category> categories;

  /// The list type to be rendered
  final CategoriesGridListType gridListType;

  /// The number of children in the cross axis.
  ///
  /// Default value is 2
  final int crossAxisCount;

  /// Empty space to inscribe inside the container containing the list
  final EdgeInsets padding;

  /// The ratio of the cross-axis to the main-axis extent of each child.
  ///
  /// Default value is 1
  final double childAspectRatio;

  CategoriesGridList({
    @required this.categories,
    @required this.gridListType,
    this.crossAxisCount = 2,
    this.padding = const EdgeInsets.all(5),
    this.childAspectRatio = 1,
  });

  Widget _gridListCardWidget(
      {@required Category category,
      @required CardCategoryDataOptions options}) {
    switch (gridListType) {
      case CategoriesGridListType.gridImageCardList:
        return CategoryImageCard(
          category: category,
          margin: const EdgeInsets.all(5),
          cardCategoryDataOptions: options,
        );
        break;
      case CategoriesGridListType.gridColoredCardList:
        return CategoryColoredCard(
          category: category,
          margin: const EdgeInsets.all(5),
          cardCategoryDataOptions: options,
        );
        break;
      default:
        return Container();
    }
  }

  @override
  Widget build(BuildContext context) {
    final appScreenOption = Provider.of<AppProvider>(context, listen: false)
        .appConfigs
        .categoriesScreen;
    final cardOptions =
        CardCategoryDataOptions.fromAppConfig(appScreenOption.options);
    return GridView.builder(
      padding: padding,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2, childAspectRatio: childAspectRatio),
      itemCount: categories.length,
      itemBuilder: (BuildContext context, int index) {
        return GestureDetector(
          onTap: () {
            Navigator.pushNamed(
              context,
              AppRoutes.category,
              arguments: categories[index],
            );
          },
          child: _gridListCardWidget(
              category: categories[index], options: cardOptions),
        );
      },
    );
  }
}
