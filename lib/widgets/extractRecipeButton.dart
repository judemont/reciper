import 'package:flutter/material.dart';
import 'package:marmiteur/marmiteur.dart';

import 'recipeEditorPage.dart';

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
              onPressed: () {
                String recipeUrl = recipeSiteUrlController.text;
                marmiteur(recipeUrl).then((value) {
                  Navigator.pop(context, 'ok');
                  if (value["name"] == null) {
                    print("Failed to extract recipe");
                    SnackBar errorBar = const SnackBar(
                      content: Text("Failed to extract recipe"),
                    );
                    ScaffoldMessenger.of(context).showSnackBar(errorBar);
                  } else {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => RecipeEditorPage(
                          initialTitle: value["name"],
                          initialIngredients:
                              ((value["recipeIngredients"]) ?? []).join("\n"),
                          initialSteps:
                              ((value["recipeInstructions"]) ?? []).join("\n"),
                        ),
                      ),
                    ).then((value) => widget.reloadRecipes());
                  }
                });
              },
              child: const Text('OK'),
            ),
          ],
        ),
      ),
    );
  }
}
