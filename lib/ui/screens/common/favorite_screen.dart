import 'package:flutter/material.dart';
import 'package:feather_icons_flutter/feather_icons_flutter.dart';
import 'package:provider/provider.dart';
import '../../../core/common/app_theme.dart';
import '../../../core/enums/ui_enums.dart';
import '../../../core/localization/transulation_constants.dart';
import '../../../core/models/post_model.dart';
import '../../../core/providers/favorite_provider.dart';
import '../../widgets/common/no_content.dart';
import '../../widgets/posts/index.dart' show PostsList;

class FavoriteScreen extends StatelessWidget {
  /// Represents the style of the list to be rendered
  ///
  /// Default selected style is cardStyleList
  final PostsListType selectedStyle = PostsListType.cardStyleList;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(transulate(context, 'my_favorite')),
        centerTitle: true,
        shape: appBarShape,
        actions: <Widget>[
          IconButton(
            icon: Icon(
              FeatherIcons.trash2,
              size: 20,
            ),
            onPressed: () async {
              await context.read<FavoriteProvider>().clearFavoritedPosts();
            },
          ),
        ],
      ),
      body: Selector<FavoriteProvider, List<Post>>(
        selector: (_, favoriteModal) => favoriteModal.favoritedPosts,
        builder: (_, List<Post> posts, __) {
          if (posts != null && posts.isNotEmpty) {
            return SingleChildScrollView(
              child: PostsList(
                posts: posts,
                padding: selectedStyle == PostsListType.cardStyleList
                    ? const EdgeInsets.all(15)
                    : null,
                listType: selectedStyle,
              ),
            );
          } else {
            return NoContent();
          }
        },
      ),
    );
  }
}
