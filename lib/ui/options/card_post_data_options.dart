import '../../core/models/app_model.dart';

class CardPostDataOptions {

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

  /// Determine whether to display post excerpt or not
  ///
  /// Default value is set to false
  final bool showPostExcerpt;

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

  const CardPostDataOptions({
    this.showDateAsTimeAgo = true,
    this.postDateFormat = 'MMM, dd yyyy',
    this.showPostExcerpt = true,
    this.showPostCommentsMeta = false,
    this.showPostCategoryMeta = true,
    this.showPostDateMeta = true,
  });

  factory CardPostDataOptions.fromAppConfig(PostsListScreenOptions options){
    return CardPostDataOptions(
      showPostDateMeta: options.showDateMeta,
      showDateAsTimeAgo: options.dateShowAsTimeAgo,
      postDateFormat: options.postDateFormat != null && options.postDateFormat.isNotEmpty ? options.postDateFormat : 'MMM, dd yyyy',
      showPostCommentsMeta: options.showCommentsMeta,
      showPostCategoryMeta: options.showCategoryMeta,
      showPostExcerpt: options.showExcerpt,
    );
  }

}
