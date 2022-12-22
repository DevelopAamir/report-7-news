import 'package:flutter/material.dart'
    show Route, RouteSettings, MaterialPageRoute, Widget;
import 'package:tuple/tuple.dart';
import 'models/category_model.dart';
import 'models/post_model.dart';
import '../ui/screens/categories/categories_list.dart';
import '../ui/screens/categories/category_screen.dart';
import '../ui/screens/comments/comments_screen.dart';
import '../ui/screens/common/favorite_screen.dart';
import '../ui/screens/common/index.dart';
import '../ui/screens/post/index.dart';
import '../ui/screens/post/posts_list_screen.dart';
import '../ui/screens/search/index.dart';
import '../ui/screens/tabs_screen.dart';

abstract class AppRoutes {
  static const String root = '/',
      categories = '/categories',
      category = '/category',
      search = '/search',
      searchResults = '/search_results',
      favorite = '/favorite',
      settings = '/settings',
      postsList = '/posts_list',
      post = '/post',
      comments = '/comments',
      contact = '/contact',
      page = '/page',
      error = '/error',
      offline = '/offline';
}

abstract class AppRouter {
  static MaterialPageRoute _route(Widget _page) =>
      MaterialPageRoute(builder: (_) => _page);

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case AppRoutes.root:
        return _route(TabsScreen());
      case AppRoutes.categories:
        return _route(CategoriesList());
      case AppRoutes.category:
        return _route(CategoryScreen(
          category: settings.arguments as Category,
        ));
      case AppRoutes.search:
        return _route(SearchScreen());
      case AppRoutes.searchResults:
        return _route(SearchResultsScreen(
          searchQuery: settings.arguments as String,
        ));
      case AppRoutes.favorite:
        return _route(FavoriteScreen());
      case AppRoutes.settings:
        return _route(SettingsScreen());
      case AppRoutes.postsList:
        final _args = settings.arguments as Tuple2<String, String>;
        return _route(PostsListScreen(
          title: _args.item1,
          query: _args.item2,
        ));
      case AppRoutes.post:
        final _args = settings.arguments as Tuple2<String, Post>;
        switch (_args.item1) {
          case 'style1':
            return _route(PostScreenOne(
              post: _args.item2,
            ));
          case 'style2':
            return _route(PostScreenTwo(
              post: _args.item2,
            ));
          case 'style3':
            return _route(PostScreenThree(
              post: _args.item2,
            ));
          default:
            return _route(PostScreenThree(
              post: _args.item2,
            ));
        }
        break;
      case AppRoutes.comments:
        final _args = settings.arguments as Tuple3<int, String, int>;
        return _route(CommentsScreen(
          postId: _args.item1,
          postCommentStatus: _args.item2,
          commentsCount: _args.item3,
        ));
      case AppRoutes.contact:
        return _route(ContactScreen());
      case AppRoutes.page:
        final _args = settings.arguments as Tuple2<int, String>;
        return _route(PageScreen(
          pageId: _args.item1,
          pageTitle: _args.item2,
        ));
      case AppRoutes.error:
        return _route(ErrorScreen());
      case AppRoutes.offline:
        return _route(OfflineScreen());
      default:
        return _route(TabsScreen());
    }
  }
}
