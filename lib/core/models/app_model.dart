import '../models/category_model.dart';

class App {
  GeneralOption appGeneralOption;
  List<HomeLayout> homeScreenLayouts;
  ScreensOptions<CategoriesScreenOptions> categoriesScreen;
  ScreensOptions<PostsListScreenOptions> postsListScreen;
  ScreensOptions<PostScreenOptions> postScreen;
  SettingScreen settingsScreen;

  App({
    this.appGeneralOption,
    this.homeScreenLayouts,
    this.categoriesScreen,
    this.postsListScreen,
    this.postScreen,
    this.settingsScreen,
  });

  factory App.fromApiJson(Map<String, dynamic> data) {
    final _generalOptions = data['general_options'];
    GeneralOption generalOption = GeneralOption.fromApiJson(_generalOptions);

    final _homeScreenData = data['home_screen'];
    final List<HomeLayout> _homeScreenLayouts = [];
    if (_homeScreenData['layouts'] != null) {
      _homeScreenData['layouts'].forEach((layout) {
        switch (layout['layout_type']) {
          case 'spotlights':
            _homeScreenLayouts.add(HomeLayout<List<int>>.fromApiJson(layout));
            break;
          case 'categories':
            _homeScreenLayouts
                .add(HomeLayout<List<Category>>.fromApiJson(layout));
            break;
          case 'posts':
            _homeScreenLayouts
                .add(HomeLayout<LayoutPostsCategory>.fromApiJson(layout));
            break;
          case 'latestposts':
            _homeScreenLayouts.add(HomeLayout<String>.fromApiJson(layout));
            break;
        }
      });
    }

    final _categoryScreenData = data['categories_screen'];
    ScreensOptions<CategoriesScreenOptions> _categoryScreenOptions =
        ScreensOptions<CategoriesScreenOptions>.fromApiJson(
            _categoryScreenData);

    final _postsListScreenData = data['posts_list_screen'];
    ScreensOptions<PostsListScreenOptions> _postsListScreenOptions =
        ScreensOptions<PostsListScreenOptions>.fromApiJson(
            _postsListScreenData);

    final _postScreenData = data['post_screen'];
    ScreensOptions<PostScreenOptions> _postScreenOptions =
        ScreensOptions<PostScreenOptions>.fromApiJson(_postScreenData);

    final _settingScreenData = data['settings_screen'];
    SettingScreen _settingScreen =
        SettingScreen.fromApiJson(_settingScreenData);

    return App(
      appGeneralOption: generalOption,
      homeScreenLayouts: _homeScreenLayouts,
      categoriesScreen: _categoryScreenOptions,
      postsListScreen: _postsListScreenOptions,
      postScreen: _postScreenOptions,
      settingsScreen: _settingScreen,
    );
  }
}

class GeneralOption {
  int contactFormId;
  bool allowComment;
  bool allowAnonymousComments;
  List<AppDrawerItem> drawerItems;

  GeneralOption({
    this.contactFormId,
    this.allowComment,
    this.allowAnonymousComments,
    this.drawerItems,
  });

  factory GeneralOption.fromApiJson(Map<String, dynamic> data) {
    final List<AppDrawerItem> _drawerItems = [];
    if (data['drawer_items'] != null) {
      data['drawer_items'].forEach((item) {
        _drawerItems.add(AppDrawerItem.fromApiJson(item));
      });
    }
    return GeneralOption(
      contactFormId: data['contact_form_id'],
      allowComment: data['allow_comment'],
      allowAnonymousComments: data['allow_anonymous_comments'],
      drawerItems: _drawerItems,
    );
  }
}

class AppDrawerItem {
  String label;
  String module;
  String value;

  AppDrawerItem({
    this.label,
    this.module,
    this.value,
  });

  factory AppDrawerItem.fromApiJson(Map<String, dynamic> data) {
    return AppDrawerItem(
      label: data['label'],
      module: data['module'],
      value: data['value'].toString(),
    );
  }
}

class HomeLayout<T> {
  String layoutType;
  T data;

  HomeLayout({this.layoutType, this.data});

  factory HomeLayout.fromApiJson(Map<String, dynamic> data) {
    T layoutData;
    if (_isOfSubtype<T, List<int>>()) {
      layoutData = data['data'].cast<int>().toList();
    } else if (_isOfSubtype<T, List<Category>>()) {
      layoutData = data['data']
          .map((d) {
            return Category.fromApiJson(d);
          })
          .cast<Category>()
          .toList();
    } else if (_isOfSubtype<T, LayoutPostsCategory>()) {
      layoutData = LayoutPostsCategory.fromApiJson(data['data']) as T;
    } else if (_isOfSubtype<T, String>()) {
      layoutData = data['data'] as T;
    }

    return HomeLayout<T>(
      layoutType: data['layout_type'],
      data: layoutData,
    );
  }

  static bool _isOfSubtype<T1, T2>() => <T1>[] is List<T2>;
}

class ScreensOptions<T> {
  String style;
  T options;

  ScreensOptions({this.style, this.options});

  factory ScreensOptions.fromApiJson(Map<String, dynamic> data) {
    T optionsData;
    if (_isOfSubtype<T, CategoriesScreenOptions>()) {
      optionsData = CategoriesScreenOptions.fromApiJson(data['options']) as T;
    } else if (_isOfSubtype<T, PostsListScreenOptions>()) {
      optionsData = PostsListScreenOptions.fromApiJson(data['options']) as T;
    } else if (_isOfSubtype<T, PostScreenOptions>()) {
      optionsData = PostScreenOptions.fromApiJson(data['options']) as T;
    }

    return ScreensOptions<T>(
      style: data['style'],
      options: optionsData,
    );
  }

  Map<String, dynamic> toJson() => {
        'style': style,
        'options': options,
      };

  static bool _isOfSubtype<T1, T2>() => <T1>[] is List<T2>;
}

class CategoriesScreenOptions {
  bool showCategoryTitle;
  bool showCategorySubtitle;
  bool showCategoryPostsCount;
  String categoryPostsCountStyle;

  CategoriesScreenOptions({
    this.showCategoryTitle,
    this.showCategorySubtitle,
    this.showCategoryPostsCount,
    this.categoryPostsCountStyle,
  });

  factory CategoriesScreenOptions.fromApiJson(Map<String, dynamic> data) {
    return CategoriesScreenOptions(
      showCategoryTitle: data['show_category_title'] ?? false,
      showCategorySubtitle: data['show_category_subtitle'] ?? false,
      showCategoryPostsCount: data['show_category_posts_count'] ?? false,
      categoryPostsCountStyle: data['category_posts_count_style'],
    );
  }

  Map<String, dynamic> toJson() => {
        'showCategoryTitle': showCategoryTitle.toString(),
        'showCategorySubtitle': showCategorySubtitle.toString(),
        'showCategoryPostsCount': showCategoryPostsCount.toString(),
        'categoryPostsCountStyle': categoryPostsCountStyle.toString(),
      };
}

class PostsListScreenOptions {
  bool showDateMeta;
  bool dateShowAsTimeAgo;
  String postDateFormat;
  bool showCommentsMeta;
  bool showViewsMeta;
  bool showCategoryMeta;
  bool showExcerpt;

  PostsListScreenOptions({
    this.showDateMeta,
    this.dateShowAsTimeAgo,
    this.postDateFormat,
    this.showCommentsMeta,
    this.showViewsMeta,
    this.showCategoryMeta,
    this.showExcerpt,
  });

  factory PostsListScreenOptions.fromApiJson(Map<String, dynamic> data) {
    return PostsListScreenOptions(
      showDateMeta: data['show_date_meta'] ?? false,
      dateShowAsTimeAgo: data['date_show_as_time_ago'] ?? false,
      postDateFormat: data['post_date_format'],
      showCommentsMeta: data['show_comments_meta'] ?? false,
      showViewsMeta: data['show_views_meta'] ?? false,
      showCategoryMeta: data['show_category_meta'] ?? false,
      showExcerpt: data['show_excerpt'] ?? false,
    );
  }

  Map<String, dynamic> toJson() => {
        'showDateMeta': showDateMeta.toString(),
        'dateShowAsTimeAgo': dateShowAsTimeAgo.toString(),
        'postDateFormat': postDateFormat.toString(),
        'showCommentsMeta': showCommentsMeta.toString(),
        'showViewsMeta': showViewsMeta.toString(),
        'showCategoryMeta': showCategoryMeta.toString(),
        'showExcerpt': showExcerpt.toString(),
      };
}

class PostScreenOptions {
  bool showDateMeta;
  bool dateShowAsTimeAgo;
  String postDateFormat;
  bool showCommentsMeta;
  bool showCommentsNavigation;
  bool showViewsMeta;
  bool showCategoryMeta;
  bool showShareOption;
  bool showFavoriteOption;
  bool showTagsList;

  PostScreenOptions({
    this.showDateMeta,
    this.dateShowAsTimeAgo,
    this.postDateFormat,
    this.showCommentsMeta,
    this.showCommentsNavigation,
    this.showViewsMeta,
    this.showCategoryMeta,
    this.showShareOption,
    this.showFavoriteOption,
    this.showTagsList,
  });

  factory PostScreenOptions.fromApiJson(Map<String, dynamic> data) {
    return PostScreenOptions(
      showDateMeta: data['show_post_date_meta'] ?? false,
      dateShowAsTimeAgo: data['post_date_show_as_time_ago'] ?? false,
      postDateFormat: data['post_post_date_format'],
      showCommentsMeta: data['post_show_comments_meta'] ?? false,
      showCommentsNavigation: data['post_show_comments_navigation'] ?? false,
      showViewsMeta: data['post_show_views_meta'] ?? false,
      showCategoryMeta: data['post_show_category_meta'] ?? false,
      showShareOption: data['post_show_share_option'] ?? false,
      showFavoriteOption: data['post_show_favorite_option'] ?? false,
      showTagsList: data['post_show_tags_list'] ?? false,
    );
  }

  Map<String, dynamic> toJson() => {
        'showDateMeta': showDateMeta.toString(),
        'dateShowAsTimeAgo': dateShowAsTimeAgo.toString(),
        'postDateFormat': postDateFormat.toString(),
        'showCommentsMeta': showCommentsMeta.toString(),
        'showCommentsNavigation': showCommentsNavigation.toString(),
        'showViewsMeta': showViewsMeta.toString(),
        'showCategoryMeta': showCategoryMeta.toString(),
        'showShareOption': showShareOption.toString(),
        'showFavoriteOption': showFavoriteOption.toString(),
        'showTagsList': showTagsList.toString(),
      };
}

class SettingScreen {
  Map<String, int> pages;
  Map<String, String> contactChannels;

  SettingScreen({this.pages, this.contactChannels});

  factory SettingScreen.fromApiJson(Map<String, dynamic> data) {
    final _pagesData = data['pages'];
    Map<String, int> _pages = {
      'faq_page': _pagesData['faq_page'],
      'privacy_policy': _pagesData['privacy_policy'],
      'terms_conditions': _pagesData['terms_conditions'],
    };

    final _contactData = data['contact'];
    Map<String, String> _contact = {
      'official_website': _contactData['settings_official_website'],
      'instagram': _contactData['settings_instagram'],
      'facebook': _contactData['settings_facebook'],
      'twitter': _contactData['settings_twitter'],
    };

    return SettingScreen(pages: _pages, contactChannels: _contact);
  }

  bool hasNoContactChannels() {
    List<String> channels = contactChannels.values.toList();
    var results =
        channels.every((element) => element == null || element.isEmpty);
    return results;
  }
}
