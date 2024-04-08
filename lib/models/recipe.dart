class Recipe {
  int? id;
  String steps;
  String servings;
  String title;
  String ingredients;

  Recipe(
      {this.id,
      this.steps = "",
      this.servings = "",
      this.title = '',
      this.ingredients = ""});

  Map<String, Object?> toMap() {
    return {
      'id': id,
      'servings': servings,
      'steps': steps,
      'title': title,
      'ingredients': ingredients,
    };
  }

  static Recipe fromMap(Map<String, dynamic> map) {
    return Recipe(
      id: map['id'] as int?,
      servings: map["servings"] ?? "",
      steps: map['steps'] ?? "",
      title: map['title'] ?? "",
      ingredients: map['ingredients'] ?? "",
    );
  }
}
