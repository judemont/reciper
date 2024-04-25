import 'package:flutter/material.dart';
import 'package:recipe_extractor/recipe_extractor.dart';
import 'package:reciper/models/recipe.dart';
import 'package:reciper/screens/pages_layout.dart';
import 'package:reciper/screens/recipe_editor.dart';

class ExtractRecipeDialog extends StatefulWidget {
  const ExtractRecipeDialog({super.key});

  @override
  State<ExtractRecipeDialog> createState() => _ExtractRecipeDialogState();
}

class _ExtractRecipeDialogState extends State<ExtractRecipeDialog> {
  @override
  Widget build(BuildContext context) {
    TextEditingController recipeSiteUrlController = TextEditingController();

    return AlertDialog(
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
            RecipeData recipeData = RecipeData();
            try {
              recipeData = await extractRecipe(recipeUrl);
            } on Exception {
              SnackBar errorBar = const SnackBar(
                content: Text("Failed to extract recipe"),
              );

              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(errorBar);
              }
            }
            if (recipeData.name == null &&
                recipeData.ingredients == null &&
                recipeData.instructions == null) {
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
                      builder: (context) => PagesLayout(
                            currentSection: 1,
                            child: RecipeEditorPage(
                              initialRecipe: Recipe(
                                title: recipeData.name ?? "",
                                servings: recipeData.servings ?? "",
                                ingredients:
                                    (recipeData.ingredients ?? []).join("\n"),
                                steps:
                                    (recipeData.instructions ?? []).join("\n"),
                                source: recipeData.source,
                              ),
                            ),
                          )),
                );
              }
            }
          },
          child: const Text('OK'),
        ),
      ],
    );
  }
}
