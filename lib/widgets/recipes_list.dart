import 'package:flutter/material.dart';
import 'package:reciper/widgets/reciper_list_tile.dart';
import '../models/recipe.dart';

class RecipeListView extends StatefulWidget {
  final List<Recipe> recipes;
  final List<int> selectedRecipesID;
  final Function(List<int>) onRecipesSelectionUpdate;
  final Function reloadRecipes;
  const RecipeListView(
      {super.key,
      required this.recipes,
      required this.onRecipesSelectionUpdate,
      required this.selectedRecipesID,
      required this.reloadRecipes});

  @override
  State<RecipeListView> createState() => _RecipeListViewState();
}

class _RecipeListViewState extends State<RecipeListView> {
  @override
  Widget build(BuildContext context) {
    List<int> selectedRecipesID = widget.selectedRecipesID;
    return ListView.builder(
      shrinkWrap: true,
      itemCount: widget.recipes.length,
      itemBuilder: (BuildContext context, int index) {
        return RecipeListTile(
            recipe: widget.recipes[index],
            selectedRecipesID: selectedRecipesID,
            onRecipesSelectionUpdate: widget.onRecipesSelectionUpdate,
            reloadRecipes: widget.reloadRecipes);
      },
    );
  }
}
