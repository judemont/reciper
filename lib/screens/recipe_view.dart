import 'package:flutter/material.dart';
import 'package:reciper/screens/pages_layout.dart';
import 'package:reciper/screens/recipe_editor.dart';
import 'package:url_launcher/url_launcher.dart';
import '../models/recipe.dart';
import 'package:wakelock_plus/wakelock_plus.dart';

class RecipeViewPage extends StatefulWidget {
  final Recipe recipe;
  final Function reloadRecipes;
  const RecipeViewPage(
      {super.key, required this.recipe, required this.reloadRecipes});
  @override
  State<RecipeViewPage> createState() => _RecipeViewPageState();
}

class _RecipeViewPageState extends State<RecipeViewPage> {
  Map<int, bool> checkboxValuesIngredients = {};
  Map<int, bool> checkboxValuesSteps = {};
  bool wakeLock = false;

  @override
  Widget build(BuildContext context) {
    List<String> ingredientsList =
        (widget.recipe.ingredients ?? "").split("\n");
    ingredientsList.removeWhere((element) => element == "");

    if (ingredientsList.isEmpty) {
      ingredientsList.add(widget.recipe.ingredients ?? "");
    }
    List<String> stepsList = (widget.recipe.steps ?? "").split("\n");
    stepsList.removeWhere((element) => element == "");
    if (stepsList.isEmpty) {
      stepsList.add(widget.recipe.ingredients ?? "");
    }

    return Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          title: const Text("Reciper"),
          centerTitle: true,
          actions: [
            Tooltip(
                message: "Prevent your phone from going to sleep",
                child: IconButton(
                  onPressed: () {
                    setState(() {
                      wakeLock = !wakeLock;
                      WakelockPlus.toggle(enable: wakeLock);

                      if (wakeLock) {
                        SnackBar message = const SnackBar(
                          content:
                              Text("Your phone won't go into standby mode"),
                        );

                        if (context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(message);
                        }
                      }
                    });
                  },
                  icon: Icon(wakeLock ? Icons.lock : Icons.lock_open),
                )),
            IconButton(
                onPressed: () {
                  Navigator.of(context)
                      .push(MaterialPageRoute(
                        builder: (context) => PagesLayout(
                            currentSection: 1,
                            child: RecipeEditorPage(
                              initialRecipe: widget.recipe,
                              isUpdate: true,
                            )),
                      ))
                      .then((value) => widget.reloadRecipes());
                },
                icon: const Icon(Icons.edit))
          ],
        ),
        body: SingleChildScrollView(
            child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.recipe.title ?? "",
                      style: const TextStyle(
                          fontSize: 30, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    Text((widget.recipe.servings ?? "").isNotEmpty
                        ? "Servings:  ${widget.recipe.servings}"
                        : ""),
                    const SizedBox(
                      height: 15,
                    ),
                    const Text(
                      "Ingredients :",
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    ListView.builder(
                        physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: ingredientsList.length,
                        itemBuilder: (BuildContext context, int index) {
                          return CheckboxListTile(
                              visualDensity: const VisualDensity(
                                  vertical: VisualDensity.minimumDensity),
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
                      "Preparation :",
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    ListView.builder(
                        physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: stepsList.length,
                        itemBuilder: (BuildContext context, int index) {
                          return CheckboxListTile(
                              controlAffinity: ListTileControlAffinity.leading,
                              value: checkboxValuesSteps[index] ?? false,
                              title: Opacity(
                                opacity: (checkboxValuesSteps[index] ?? false)
                                    ? 0.5
                                    : 1,
                                child: Text(
                                  stepsList[index],
                                ),
                              ),
                              onChanged: (value) {
                                setState(() {
                                  checkboxValuesSteps[index] = value!;
                                });
                              });
                        }),
                    Visibility(
                        visible: Uri.tryParse(widget.recipe.source ?? "")
                                ?.isAbsolute ??
                            false,
                        child: ListTile(
                            title: Text(
                              "Source: ${widget.recipe.source}",
                              style: const TextStyle(color: Colors.blue),
                            ),
                            onTap: () {
                              launchUrl(Uri.parse(widget.recipe.source!));
                            }))
                  ],
                ))));
  }
}
