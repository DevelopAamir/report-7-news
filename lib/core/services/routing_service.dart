import 'package:flutter/material.dart' show BuildContext, Navigator, required;
import 'package:tuple/tuple.dart' show Tuple2;
import '../enums/core_enums.dart' show RoutingScheme;
import '../models/app_model.dart' show AppDrawerItem;
import '../models/category_model.dart';
import '../models/post_model.dart';
import '../models/routing_data.dart';
import '../repositories/post_repository.dart';
import '../router.dart' show AppRoutes;
import '../utils/api_response.dart';
import '../utils/tools.dart' as tools show openURL;
import '../utils/ui_helper.dart' as uiHelper show showLoadingDialog, hideLoadingDialog;

class RoutingService {
  final BuildContext _context;
  final PostRepository _postRepository = PostRepository();

  RoutingService._(this._context);

  static RoutingService of(BuildContext context) {
    return RoutingService._(context);
  }

  void navigate<T>({
    @required RoutingScheme scheme,
    @required T data,
  }) {
    try {
      final _navigationData = _parseData<T>(scheme, data);
      _moduleNavigation(_navigationData);
    } catch (e) {
      print(e);
    }
  }

  RoutingData _parseData<T>(RoutingScheme scheme, T data) {
    switch (scheme) {
      case RoutingScheme.drawer:
        final AppDrawerItem _drawerItemData = data as AppDrawerItem;
        return RoutingData.fromDrawerItem(_drawerItemData);
        break;
      case RoutingScheme.pushNotification:
        final Map<String, dynamic> _notificationData = data as Map<String, dynamic>;
        return RoutingData.fromNotificationAdditionalData(_notificationData);
        break;
      default:
    }
    return null;
  }

  void _moduleNavigation(RoutingData data) {
    if (data != null && data.module != null && data.module.isNotEmpty) {
      switch (data.module) {
        case AppRoutes.page:
          _pageNavigation(data);
          break;
        case AppRoutes.post:
          _postNaviagtion(data);
          break;
        case AppRoutes.category:
          _categoryNaviagtion(data);
          break;
        case 'external':
          _navigateToURL(data.value);
          break;
        default:
          Navigator.pushNamed(_context, data.module);
      }
    }
  }

  void _pageNavigation(RoutingData data) {
    if (data.label != null && data.value != null && data.value.isNotEmpty) {
      final Tuple2<int, String> _pageData = Tuple2<int, String>(
        int.tryParse(data.value),
        data.label,
      );
      Navigator.pushNamed(
        _context,
        AppRoutes.page,
        arguments: _pageData,
      );
    }
  }

  Future<void> _postNaviagtion(RoutingData data) async {
    if (data.value != null && data.value.isNotEmpty) {
      try {
        uiHelper.showLoadingDialog(_context);
        ApiResponse<Post> _res = await _postRepository.getPost(data.value);
        if (!_res.error && _res.data != null) {
          uiHelper.hideLoadingDialog(_context);
          Navigator.pushNamed(
            _context,
            AppRoutes.post,
            arguments: Tuple2<String, Post>('', _res.data),
          );
        }
      } catch (e) {
        uiHelper.hideLoadingDialog(_context);
      }
    }
  }

  void _categoryNaviagtion(RoutingData data) {
    if (data.label != null && data.value != null && data.value.isNotEmpty) {
      final Category _category = Category.fromRoutingData(data);
      Navigator.pushNamed(
        _context,
        AppRoutes.category,
        arguments: _category,
      );
    }
  }

  void _navigateToURL(String url) {
    if (url != null && url.isNotEmpty) {
      tools.openURL(url);
    }
  }
}
