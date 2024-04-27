class TagLink {
  int? recipeId;
  int? tagId;

  TagLink({this.recipeId, this.tagId});

  Map<String, Object?> toMap() {
    return {'recipeId': recipeId, 'tagId': tagId};
  }

  static TagLink fromMap(Map<String, dynamic> map) {
    return TagLink(
      recipeId: map['recipeId'],
      tagId: map['tagId'],
    );
  }
}
