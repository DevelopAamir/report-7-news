import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/enums/ui_enums.dart';
import '../../../../core/models/post_model.dart';
import '../../../../core/providers/app_provider.dart';
import '../../../options/card_post_data_options.dart';
import '../index.dart' show ListPostCard, PostCard;

class PostsList extends StatelessWidget {
  /// Posts Llist to be rendered with the list
  final List<Post> posts;

  /// Empty space to inscribe inside the container containing the list
  final EdgeInsets padding;

  /// Empty space to surround the container containing the list
  final EdgeInsets margin;

  /// The list type to be rendered
  final PostsListType listType;

  PostsList({
    @required this.posts,
    @required this.listType,
    this.padding,
    this.margin,
  });

  /// Render the list based on the selected list type
  Widget _listCardWidget(
      {@required BuildContext context, @required Post post}) {
    final appScreenOption = Provider.of<AppProvider>(context, listen: false)
        .appConfigs
        .postsListScreen;
    final cardPostDataOptions =
        CardPostDataOptions.fromAppConfig(appScreenOption.options);
    switch (listType) {
      case PostsListType.verticalList:
        return ListPostCard(
          post: post,
          cardPostDataOptions: cardPostDataOptions,
          padding: const EdgeInsets.all(15),
        );
        break;
      case PostsListType.cardStyleList:
        return PostCard(
          post: post,
          cardPostDataOptions: cardPostDataOptions,
          margin: const EdgeInsets.only(bottom: 15),
        );
        break;
      case PostsListType.cardTypeTwoStyleList:
        return PostCard(
          post: post,
          cardRadius: 0,
          cardPostDataOptions: cardPostDataOptions,
          margin: const EdgeInsets.only(bottom: 15),
        );
        break;
      default:
        return Container();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding,
      margin: margin,
      child: ListView.builder(
        shrinkWrap: true,
        primary: false,
        itemCount: posts.length,
        itemBuilder: (BuildContext context, int index) {
          return _listCardWidget(context: context, post: posts[index]);
        },
      ),
    );
  }
}
