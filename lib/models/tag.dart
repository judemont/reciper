class Tag {
  int? id;
  String? name;

  Tag({this.id, this.name});

  Map<String, Object?> toMap() {
    return {'id': id, 'name': name};
  }

  static Tag fromMap(Map<String, dynamic> map) {
    return Tag(
      id: map['id'],
      name: map['name'],
    );
  }
}
