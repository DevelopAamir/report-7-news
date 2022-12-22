class Tag{
  int id;
  String name;

  Tag({this.id, this.name});

  factory Tag.fromApiJson(Map<String, dynamic> data) {
    return Tag(
      id: data['term_id'],
      name: data['name'],
    );
  }

  factory Tag.fromLocalJson(Map<String, dynamic> data){
    return Tag(
      id: data['id'],
      name: data['name'],
    );
  }

  Map<String, dynamic> toJson(){
    return {
      'id': id,
      'name': name,
    };
  }
}