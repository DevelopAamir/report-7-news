import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/models/post_model.dart';
import '../../../../core/providers/favorite_provider.dart';

class FavoritePost extends StatelessWidget {
  final Post post;
  final double iconSize;
  final bool isBottomNavigation;
  FavoritePost(
      {@required this.post, this.iconSize, this.isBottomNavigation = false});

  @override
  Widget build(BuildContext context) {
    return Selector<FavoriteProvider, bool>(
      selector: (_, favoriteModel) => favoriteModel.isFavoritedPost(post.id),
      builder: (_, bool isFavorited, __) {
        return IconButton(
          padding: EdgeInsets.zero,
          constraints: isBottomNavigation ? BoxConstraints() : null,
          icon: Icon(
            isFavorited ? Icons.favorite : Icons.favorite_outline,
            size: 26,
          ),
          color: isFavorited ? Colors.red : null,
          onPressed: () {
            context.read<FavoriteProvider>().favoritePost(post);
          },
        );
      },
    );
  }
}
