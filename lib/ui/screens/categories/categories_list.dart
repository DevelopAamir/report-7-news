import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/enums/ui_enums.dart';
import '../../../ui/widgets/categories/index.dart'
    show CategoriesGridList, CategoriesVerticalList;
import '../../../ui/widgets/common/data_loading.dart';
import '../../../ui/widgets/common/error_message.dart';
import '../../../core/common/app_theme.dart';
import '../../../core/localization/transulation_constants.dart';
import '../../../core/models/category_model.dart';
import '../../../core/providers/app_provider.dart';
import '../../../core/repositories/category_repository.dart';
import '../../../core/utils/api_response.dart';

class CategoriesList extends StatelessWidget {

  final CategoryRepository _categoryRepository = CategoryRepository();

  dynamic categoriesListStyle(String listStyle){
    switch (listStyle) {
      case 'grid1':
        return CategoriesGridListType.gridImageCardList;
      case 'grid2':
        return CategoriesGridListType.gridColoredCardList;
      case 'vertical1':
        return CategoriesVerticalListType.verticalImageCardList;
      case 'vertical2':
        return CategoriesVerticalListType.verticalThumbnailList;
      case 'vertical3':
        return CategoriesVerticalListType.verticallList;
      default:
        return CategoriesGridListType.gridImageCardList;
    }
  }

  /// Rednder the view of the Grid Widget Layout based on the Grid List Type
  Widget _renderGridWidgetLists({@required List<Category> categories, @required dynamic selectedStyle}) {
    switch (selectedStyle) {
      case CategoriesGridListType.gridImageCardList:
        return CategoriesGridList(
          categories: categories,
          gridListType: CategoriesGridListType.gridImageCardList,
        );
        break;
      case CategoriesGridListType.gridColoredCardList:
        return CategoriesGridList(
          categories: categories,
          gridListType: CategoriesGridListType.gridColoredCardList,
        );
        break;
      default:
        return Container();
    }
  }

  /// Rednder the view of the Vertical List Widget Layout based on the Vertical List Type
  Widget _renderVerticalWidgetLists({@required List<Category> categories, @required dynamic selectedStyle}) {
    switch (selectedStyle) {
      case CategoriesVerticalListType.verticalImageCardList:
        return CategoriesVerticalList(
          categories: categories,
          verticalListType: CategoriesVerticalListType.verticalImageCardList,
          padding: const EdgeInsets.all(5),
        );
        break;
      case CategoriesVerticalListType.verticalThumbnailList:
        return CategoriesVerticalList(
          categories: categories,
          verticalListType: CategoriesVerticalListType.verticalThumbnailList,
        );
        break;
      case CategoriesVerticalListType.verticallList:
        return CategoriesVerticalList(
          categories: categories,
          verticalListType: CategoriesVerticalListType.verticallList,
        );
        break;
      default:
        return Container();
    }
  }

  @override
  Widget build(BuildContext context) {
    final appScreenOption = Provider.of<AppProvider>(context, listen: false).appConfigs.categoriesScreen;
    final selectedStyle = categoriesListStyle(appScreenOption.style);
    return Scaffold(
      appBar: AppBar(
        title: Text(transulate(context, 'categories')),
        shape: appBarShape,
      ),
      body: FutureBuilder(
        future: _categoryRepository.getCategories(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return DataLoading();
          } else {
            if (snapshot.error != null) {
              return ErrorMessage();
            } else {
              ApiResponse<List<Category>> _response =
                  snapshot.data as ApiResponse<List<Category>>;

              if(_response.error){
                return ErrorMessage(message: _response.message,);
              }else{
                return selectedStyle is CategoriesGridListType
                  ? _renderGridWidgetLists(categories: _response.data, selectedStyle: selectedStyle)
                  : _renderVerticalWidgetLists(categories: _response.data, selectedStyle: selectedStyle);
              }
        
            }
          }
        },
      ),
    );
  }
}
