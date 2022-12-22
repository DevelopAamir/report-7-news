import '../../core/enums/ui_enums.dart' show CategoryPostsCountStyle;
import '../../core/models/app_model.dart';

class CardCategoryDataOptions {

  /// Determine whether to display post date as Timeago format or not
  ///
  /// Default value is set to false
  final bool showCategoryTitle;

  /// Determine whether to display post excerpt or not
  ///
  /// Default value is set to false
  final bool showCategorySubtitle;

  /// Determine whether to display post comments meta or not
  ///
  /// Default value is set to true
  final bool showCategoryPostsCount;

  /// Determine whether to display post views meta or not
  ///
  /// Default value is set to true
  final CategoryPostsCountStyle categoryPostsCountStyle;


  const CardCategoryDataOptions({
    this.showCategoryTitle = true,
    this.showCategorySubtitle = true,
    this.showCategoryPostsCount = true,
    this.categoryPostsCountStyle = CategoryPostsCountStyle.circleBadge,
  });

  factory CardCategoryDataOptions.fromAppConfig(CategoriesScreenOptions options){
    CategoryPostsCountStyle countStyle;
    switch (options.categoryPostsCountStyle) {
      case 'labelStyle':
        countStyle = CategoryPostsCountStyle.labelStyle;
        break;
      case 'circleBadge':
        countStyle = CategoryPostsCountStyle.circleBadge;
        break;
      case 'sequareBadge':
        countStyle = CategoryPostsCountStyle.sequareBadge;
        break;
    }
    return CardCategoryDataOptions(
      showCategoryTitle: options.showCategoryTitle,
      showCategorySubtitle: options.showCategorySubtitle,
      showCategoryPostsCount: options.showCategoryPostsCount,
      categoryPostsCountStyle: countStyle,
    );
  }

  @override
  String toString() {
    return 'showCategoryTitle: $showCategoryTitle - showCategorySubtitle: $showCategorySubtitle - showCategoryPostsCount: $showCategoryPostsCount - categoryPostsCountStyle: $categoryPostsCountStyle';
  }

}
