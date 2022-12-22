class Page{

  int id;
  String title;
  String content;

  Page({
    this.id,
    this.title,
    this.content,
  });

  factory Page.fromApiJson(Map<String, dynamic> data) {
    return Page(
      id: data['id'],
      title: data['name'],
      content: data['content']['rendered'],
    );
  }

  factory Page.fromApiOptionsJson(Map<String, dynamic> data) {
    return Page(
      id: data['ID'],
      title: data['post_title'],
      content: data['post_content'],
    );
  }

}