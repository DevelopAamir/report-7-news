import '../utils/tools.dart' as tools show parseHtmlString;
import 'tag_model.dart';

class Post{
  int id;
  String title;
  String excerpt;
  String thumbnail;
  String category;
  String link;
  int views;
  int comments;
  String htmlContent;
  String commentStatus;
  List<Tag> tags;
  DateTime createdAt;

  Post({
    this.id,
    this.title,
    this.excerpt,
    this.thumbnail,
    this.category,
    this.link,
    this.comments,
    this.htmlContent,
    this.commentStatus,
    this.tags,
    this.createdAt,
  });

  factory Post.fromApiJson(Map<String, dynamic> data) {
    List<Tag> _tagsList = [];
    if(data['lucodeia_tags'] != null){
      data['lucodeia_tags'].forEach((tag){
        _tagsList.add(Tag.fromApiJson(tag));
      });
    }
    return Post(
      id: data['id'],
      title: data['title']['rendered'],
      excerpt: tools.parseHtmlString(data['excerpt']['rendered']),
      thumbnail: data['lucodeia_thumbnail'],
      category: data['lucodeia_category'],
      link: data['link'],
      comments: data['lucodeia_comments_count'],
      htmlContent: data['content']['rendered'],
      commentStatus: data['comment_status'],
      tags: _tagsList,
      createdAt: data['date'] != null ? DateTime.parse(data['date']) : null,
    );
  }

  factory Post.fromLocalJson(Map<String, dynamic> data){
    List<Tag> _tagsList = [];
    if(data['tags'] != null){
      data['tags'].forEach((tag){
        _tagsList.add(Tag.fromLocalJson(tag));
      });
    }
    return Post(
      id: data['id'],
      title: data['title'],
      excerpt: data['excerpt'],
      thumbnail: data['thumbnail'],
      category: data['category'],
      link: data['link'],
      comments: data['comments'],
      htmlContent: data['htmlContent'],
      tags: _tagsList,
      createdAt: DateTime.parse(data['createdAt']),
    );
  }

  Map<String, dynamic> toJson(){
    return {
      'id': id,
      'title': title,
      'excerpt': excerpt,
      'thumbnail': thumbnail,
      'category': category,
      'link': link,
      'views': views,
      'comments': comments,
      'htmlContent': htmlContent,
      'tags': tags,
      'createdAt': createdAt.toString(),
    };
  }

}