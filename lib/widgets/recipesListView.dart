import 'package:flutter/material.dart';
import 'recipeViewPage.dart';
import '../models/recipe.dart';

class RecipeListView extends StatefulWidget {
  final List<Recipe> recipes;
  final List<int> selectedRecipesID;
  Function(List<int>) onRecipesSelectionUpdate;
  RecipeListView(
      {super.key,
      required this.recipes,
      required this.onRecipesSelectionUpdate,
      required this.selectedRecipesID});

  @override
  State<RecipeListView> createState() => _RecipeListViewState();
}

class _RecipeListViewState extends State<RecipeListView> {
  @override
  Widget build(BuildContext context) {
    List<int> selectedRecipesID = widget.selectedRecipesID;
    print(widget.recipes);
    return Wrap(children: [
      ListView.builder(
        shrinkWrap: true,
        itemCount: widget.recipes.length,
        itemBuilder: (BuildContext context, int index) {
          return ListTile(
            title: Text(widget.recipes[index].title),
            selected: selectedRecipesID.contains(widget.recipes[index].id),
            selectedColor: Colors.white,
            selectedTileColor: const Color.fromARGB(255, 63, 63, 63),
            onLongPress: () {
              if (selectedRecipesID.contains(widget.recipes[index].id)) {
                selectedRecipesID.remove(widget.recipes[index].id);
              } else {
                selectedRecipesID.add(widget.recipes[index].id!);
              }
              widget.onRecipesSelectionUpdate(selectedRecipesID);

              print(selectedRecipesID);
            },
            onTap: () {
              print(selectedRecipesID);

              if (selectedRecipesID.contains(widget.recipes[index].id!)) {
                selectedRecipesID.remove(widget.recipes[index].id!);
              } else if (selectedRecipesID.isNotEmpty) {
                selectedRecipesID.add(widget.recipes[index].id!);
              } else {
                Navigator.of(context).push(
                  MaterialPageRoute(
                      builder: (context) =>
                          RecipeViewPage(recipe: widget.recipes[index])),
                );
              }

              widget.onRecipesSelectionUpdate(selectedRecipesID);
            },
          );
        },
      )
    ]);
  }
}
