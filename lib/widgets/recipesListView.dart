import 'package:flutter/material.dart';
import 'recipeViewPage.dart';
import '../models/recipe.dart';

class RecipeListView extends StatefulWidget {
  final List<Recipe> recipes;
  const RecipeListView({super.key, required this.recipes});

  @override
  State<RecipeListView> createState() => _RecipeListViewState();
}

class _RecipeListViewState extends State<RecipeListView> {
  @override
  Widget build(BuildContext context) {
    print(widget.recipes);
    return Wrap(children: [
      ListView.builder(
        shrinkWrap: true,
        itemCount: widget.recipes.length,
        itemBuilder: (BuildContext context, int index) {
          return ListTile(
            title: Text(widget.recipes[index].title),
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                    builder: (context) =>
                        RecipeViewPage(recipe: widget.recipes[index])),
              );
            },
          );
        },
      )
    ]);
  }
}
