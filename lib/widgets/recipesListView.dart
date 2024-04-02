import 'package:flutter/material.dart';
import 'recipeViewPage.dart';
import '../models/recipe.dart';

class RecipeListView extends StatefulWidget {
  final List<Recipe> recipes;
  Function setSelecting;
  RecipeListView(
      {super.key, required this.recipes, required this.setSelecting});

  @override
  State<RecipeListView> createState() => _RecipeListViewState();
}

class _RecipeListViewState extends State<RecipeListView> {
  Map<int, bool> selectedTiles = {};

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
            selected: selectedTiles[index] ?? false,
            selectedColor: Colors.white,
            selectedTileColor: const Color.fromARGB(255, 63, 63, 63),
            onLongPress: () {
              setState(() {
                selectedTiles[index] = !(selectedTiles[index] ?? false);
                widget.setSelecting(selectedTiles.containsValue(true));
              });

              print(selectedTiles);
            },
            onTap: () {
              print(selectedTiles);
              setState(() {
                if (selectedTiles[index] ?? false) {
                  selectedTiles[index] = false;
                  widget.setSelecting(selectedTiles.containsValue(true));
                } else if (selectedTiles.containsValue(true)) {
                  selectedTiles[index] = true;
                } else {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                        builder: (context) =>
                            RecipeViewPage(recipe: widget.recipes[index])),
                  );
                }
              });
            },
          );
        },
      )
    ]);
  }
}
