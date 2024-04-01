class Recipe {
  int? id;
  String steps;
  String title;
  String ingredients;

  Recipe({this.id, this.steps = "", this.title = '', this.ingredients = ""});

  Map<String, Object?> toMap() {
    return {
      'id': id,
      'steps': steps,
      'title': title,
      'ingredients': ingredients,
    };
  }

  static Recipe fromMap(Map<String, Object?> map) {
    return Recipe(
      id: map['id'] as int,
      steps: map['steps'] as String,
      title: map['title'] as String,
      ingredients: map['ingredients'] as String,
    );
  }
}
