import '../utils/tools.dart' as tools show parseHtmlString;

class Comment{

  int id;
  String name;
  String avatar;
  String comment;
  String status;
  DateTime date;

  Comment({
    this.id,
    this.name,
    this.avatar,
    this.comment,
    this.status,
    this.date,
  });

  factory Comment.fromApiJson(Map<String, dynamic> data) {
    return Comment(
      id: data['id'],
      name: data['author_name'],
      avatar: data['author_avatar_urls']['96'],
      comment: tools.parseHtmlString(data['content']['rendered']),
      status: data['status'],
      date: data['date'] != null ? DateTime.parse(data['date']) : null,
    );
  }


}