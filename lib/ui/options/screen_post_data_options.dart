import '../../core/models/app_model.dart';

class ScreenPostDataOptions {

  /// Determine whether to display post comments meta or not
  ///
  /// Default value is set to true
  final bool showPostCommentsMeta;

  /// Determine whether to display post cateogry meta or not
  ///
  /// Default value is set to true
  final bool showPostCategoryMeta;

  /// Determine whether to display post date meta or not
  ///
  /// Default value is set to true
  final bool showPostDateMeta;

  /// Determine whether to display post date as Timeago format or not
  ///
  /// Default value is set to false
  final bool showDateAsTimeAgo;

  /// The format of post date
  ///
  /// Default format is MMM, dd yyyy
  ///
  /// Date will be formatted with intl package
  final String postDateFormat;

  /// Determine whether to display comments navigation
  ///
  /// Default value is set to true
  final bool showCommentsNavigation;

  /// Determine whether to display share option
  ///
  /// Default value is set to true
  final bool showShareOption;

  /// Determine whether to display favorite option
  ///
  /// Default value is set to true
  final bool showFavoriteOption;

  /// Determine whether to display favorite option
  ///
  /// Default value is set to true
  final bool showTagsList;

  const ScreenPostDataOptions({
    this.showPostCommentsMeta = true,
    this.showPostCategoryMeta = true,
    this.showPostDateMeta = true,
    this.showDateAsTimeAgo = false,
    this.postDateFormat = 'MMM, dd yyyy',
    this.showCommentsNavigation = true,
    this.showShareOption = true,
    this.showFavoriteOption = true,
    this.showTagsList = true,
  });

  factory ScreenPostDataOptions.fromAppConfig(PostScreenOptions options){
    return ScreenPostDataOptions(
      showPostCommentsMeta: options.showCommentsMeta,
      showPostCategoryMeta: options.showCategoryMeta,
      showPostDateMeta: options.showDateMeta,
      showDateAsTimeAgo: options.dateShowAsTimeAgo,
      postDateFormat: options.postDateFormat != null && options.postDateFormat.isNotEmpty ? options.postDateFormat : 'MMM, dd yyyy',
      showCommentsNavigation: options.showCommentsNavigation,
      showShareOption: options.showShareOption,
      showFavoriteOption: options.showFavoriteOption,
      showTagsList: options.showTagsList,
    );
  }

}
