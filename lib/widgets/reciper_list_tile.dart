import 'package:flutter/material.dart';
import 'package:reciper/models/recipe.dart';
import 'package:reciper/screens/pages_layout.dart';
import 'package:reciper/screens/recipe_view.dart';

class RecipeListTile extends StatefulWidget {
  final List<int> selectedRecipesID;
  final Recipe recipe;
  final Function(List<int>) onRecipesSelectionUpdate;
  final Function reloadRecipes;
  const RecipeListTile(
      {super.key,
      required this.recipe,
      required this.selectedRecipesID,
      required this.onRecipesSelectionUpdate,
      required this.reloadRecipes});

  @override
  State<RecipeListTile> createState() => _RecipeListTileState();
}

class _RecipeListTileState extends State<RecipeListTile> {
  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(widget.recipe.title ?? ""),
      selected: widget.selectedRecipesID.contains(widget.recipe.id),
      onLongPress: () {
        if (widget.selectedRecipesID.contains(widget.recipe.id)) {
          widget.selectedRecipesID.remove(widget.recipe.id);
        } else {
          widget.selectedRecipesID.add(widget.recipe.id!);
        }
        widget.onRecipesSelectionUpdate(widget.selectedRecipesID);
      },
      onTap: () {
        if (widget.selectedRecipesID.contains(widget.recipe.id!)) {
          widget.selectedRecipesID.remove(widget.recipe.id!);
        } else if (widget.selectedRecipesID.isNotEmpty) {
          widget.selectedRecipesID.add(widget.recipe.id!);
        } else {
          Navigator.of(context).push(
            MaterialPageRoute(
                builder: (context) => PagesLayout(
                      displayBottomNavBar: false,
                      child: RecipeViewPage(
                        recipe: widget.recipe,
                        reloadRecipes: widget.reloadRecipes,
                      ),
                    )),
          );
        }

        widget.onRecipesSelectionUpdate(widget.selectedRecipesID);
      },
    );
  }
}
