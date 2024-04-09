class Recipe {
  int? id;
  String? steps;
  String? servings;
  String? title;
  String? ingredients;
  String? source;

  Recipe(
      {this.id,
      this.steps,
      this.servings,
      this.title,
      this.ingredients,
      this.source});

  Map<String, Object?> toMap() {
    return {
      'id': id,
      'servings': servings,
      'steps': steps,
      'title': title,
      'ingredients': ingredients,
      'source': source,
    };
  }

  static Recipe fromMap(Map<String, dynamic> map) {
    return Recipe(
      id: map['id'],
      servings: map["servings"],
      steps: map['steps'],
      title: map['title'],
      ingredients: map['ingredients'],
      source: map['source'],
    );
  }
}
