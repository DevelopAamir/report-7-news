import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/enums/ui_enums.dart';
import '../../../../core/models/category_model.dart';
import '../../../../core/providers/app_provider.dart';
import '../../../../core/router.dart';
import '../../../options/card_category_data_options.dart';
import '../index.dart' show CategoryImageCard, CategoryListCard;

class CategoriesVerticalList extends StatelessWidget {
  /// Categories List to be rendered
  final List<Category> categories;

  /// The list type to be rendered
  final CategoriesVerticalListType verticalListType;

  /// Empty space to inscribe inside the container containing the list
  final EdgeInsets padding;

  CategoriesVerticalList({
    @required this.categories,
    @required this.verticalListType,
    this.padding,
  });

  /// Render the list based on the selected list type
  Widget _verticalListCardWidget(
      {@required Category category,
      @required CardCategoryDataOptions options}) {
    switch (verticalListType) {
      case CategoriesVerticalListType.verticalImageCardList:
        return CategoryImageCard(
          category: category,
          width: double.infinity,
          height: 150,
          margin: const EdgeInsets.all(5),
          cardCategoryDataOptions: options,
        );
        break;
      case CategoriesVerticalListType.verticalThumbnailList:
        return CategoryListCard(
          category: category,
          padding: const EdgeInsets.all(10),
          showCategoryImage: true,
          cardCategoryDataOptions: options,
        );
        break;
      case CategoriesVerticalListType.verticallList:
        return CategoryListCard(
          category: category,
          padding: const EdgeInsets.all(10),
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
    return ListView.builder(
      padding: padding,
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
          child: _verticalListCardWidget(
              category: categories[index], options: cardOptions),
        );
      },
    );
  }
}
