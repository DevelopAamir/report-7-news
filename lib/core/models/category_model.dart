import 'dart:ui';
import '../utils/tools.dart' show convertHexToColor;
import 'routing_data.dart';

class Category {
  int id;
  String title;
  String subtitle;
  String image;
  int postsCount;
  Color cardColor;

  Category({
    this.id,
    this.title,
    this.subtitle,
    this.image,
    this.postsCount,
    this.cardColor,
  });

  factory Category.fromApiJson(Map<String, dynamic> data) {
    return Category(
        id: data['id'],
        title: data['name'],
        subtitle: data['description'],
        image: data['lucodeia_category_image'] != false
            ? data['lucodeia_category_image']
            : null,
        postsCount: data['count'],
        cardColor: convertHexToColor(data['lucodeia_category_color']));
  }

  factory Category.fromRoutingData(RoutingData data) {
    return Category(
      id: int.tryParse(data.value),
      title: data.label,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'subtitle': subtitle,
        'image': image,
        'postsCount': postsCount,
        'cardColor': cardColor != null ? cardColor.value : null,
      };
}

class LayoutPostsCategory {
  int id;
  String title;

  LayoutPostsCategory({
    this.id,
    this.title,
  });

  factory LayoutPostsCategory.fromApiJson(Map<String, dynamic> data) {
    return LayoutPostsCategory(
      id: data['term_id'],
      title: data['name'],
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
      };
}
