import 'package:flutter/material.dart';
import '../models/recipe.dart';

class RecipeViewPage extends StatefulWidget {
  final Recipe recipe;
  const RecipeViewPage({super.key, required this.recipe});
  @override
  State<RecipeViewPage> createState() => _RecipeViewPageState();
}

class _RecipeViewPageState extends State<RecipeViewPage> {
  Map<int, bool> checkboxValuesIngredients = {};
  Map<int, bool> checkboxValuesSteps = {};

  @override
  Widget build(BuildContext context) {
    List<String> ingredientsList = widget.recipe.ingredients.split("\n");
    if (ingredientsList.isEmpty) {
      ingredientsList.add(widget.recipe.ingredients);
    }
    List<String> stepsList = widget.recipe.steps.split("\n");
    if (stepsList.isEmpty) {
      stepsList.add(widget.recipe.ingredients);
    }

    return Scaffold(
        appBar: AppBar(
          title: const Text("Reciper"),
          centerTitle: true,
          actions: [IconButton(onPressed: () {}, icon: const Icon(Icons.edit))],
        ),
        body: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.recipe.title,
                  style: const TextStyle(
                      fontSize: 30, fontWeight: FontWeight.bold),
                ),
                const SizedBox(
                  height: 15,
                ),
                const Text(
                  "Ingredients :",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                ListView.builder(
                    shrinkWrap: true,
                    itemCount: ingredientsList.length,
                    itemBuilder: (BuildContext context, int index) {
                      return CheckboxListTile(
                          controlAffinity: ListTileControlAffinity.leading,
                          value: checkboxValuesIngredients[index] ?? false,
                          title: Text(ingredientsList[index]),
                          onChanged: (value) {
                            setState(() {
                              checkboxValuesIngredients[index] = value!;
                            });
                          });
                    }),
                const Text(
                  "Steps :",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                ListView.builder(
                    shrinkWrap: true,
                    itemCount: stepsList.length,
                    itemBuilder: (BuildContext context, int index) {
                      return CheckboxListTile(
                          controlAffinity: ListTileControlAffinity.leading,
                          value: checkboxValuesSteps[index] ?? false,
                          title: Text(stepsList[index]),
                          onChanged: (value) {
                            setState(() {
                              checkboxValuesSteps[index] = value!;
                            });
                          });
                    }),
              ],
            )));
  }
}
