import 'package:flutter/material.dart';
import 'package:recipe_extractor/recipe_extractor.dart';
import 'package:reciper/models/recipe.dart';
import 'recipe_editor_page.dart';

class ExtractRecipeButton extends StatefulWidget {
  final Function reloadRecipes;

  const ExtractRecipeButton({super.key, required this.reloadRecipes});

  @override
  State<ExtractRecipeButton> createState() => _ExtractRecipeButtonState();
}

class _ExtractRecipeButtonState extends State<ExtractRecipeButton> {
  @override
  Widget build(BuildContext context) {
    TextEditingController recipeSiteUrlController = TextEditingController();

    return FloatingActionButton(
      child: const Icon(Icons.add_link),
      onPressed: () => showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text("Extract recipe from a website"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: recipeSiteUrlController,
                decoration:
                    const InputDecoration(hintText: "Enter Recipe website url"),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, 'Cancel'),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                String recipeUrl = recipeSiteUrlController.text;
                RecipeData recipeData = await extractRecipe(recipeUrl);

                if (recipeData.name == null) {
                  print("Failed to extract recipe");
                  SnackBar errorBar = const SnackBar(
                    content: Text("Failed to extract recipe"),
                  );

                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(errorBar);
                  }
                } else {
                  if (context.mounted) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => RecipeEditorPage(
                          initialRecipe: Recipe(
                            title: recipeData.name ?? "",
                            servings: recipeData.servings ?? "",
                            ingredients:
                                (recipeData.ingredients ?? []).join("\n"),
                            steps: (recipeData.instructions ?? []).join("\n"),
                          ),
                        ),
                      ),
                    ).then((value) => widget.reloadRecipes());
                  }
                }
              },
              child: const Text('OK'),
            ),
          ],
        ),
      ),
    );
  }
}
