import 'package:flutter/material.dart';
import 'package:reciper/screens/pages_layout.dart';
import 'package:reciper/utilities/database.dart';
import 'package:reciper/models/recipe.dart';
import 'package:reciper/screens/home.dart';
import 'package:reciper/widgets/extract_recipe_button.dart';

class RecipeEditorPage extends StatefulWidget {
  // final String initialTitle;
  // final String initialIngredients;
  // final String initialSteps;
  // final int? recipeID;
  final Recipe? initialRecipe;
  final bool isUpdate;
  const RecipeEditorPage(
      {super.key, this.initialRecipe, this.isUpdate = false});

  @override
  State<RecipeEditorPage> createState() => _RecipeEditorPageState();
}

class _RecipeEditorPageState extends State<RecipeEditorPage> {
  final double fieldsMargin = 30.0;
  final formKey = GlobalKey<FormState>();
  String title = "";
  String ingredients = "";
  String steps = "";
  String servings = "";
  String source = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: true,
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: const Text("New Recipe"),
          centerTitle: true,
          actions: [
            IconButton(
                onPressed: () {
                  if (formKey.currentState!.validate()) {
                    formKey.currentState!.save();

                    if (!widget.isUpdate) {
                      DatabaseService.createRecipe(Recipe(
                          title: title,
                          servings: servings,
                          steps: steps,
                          ingredients: ingredients,
                          source: source));
                    } else {
                      DatabaseService.updateRecipe(Recipe(
                          id: widget.initialRecipe!.id,
                          servings: servings,
                          title: title,
                          steps: steps,
                          ingredients: ingredients,
                          source: source));
                    }

                    Navigator.of(context).push(
                      MaterialPageRoute(
                          builder: (context) =>
                              const PagesLayout(child: HomePage())),
                    );
                  }
                },
                icon: const Icon(Icons.check))
          ],
        ),
        floatingActionButton: const ExtractRecipeButton(),
        body: SingleChildScrollView(
            child: Form(
          key: formKey,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 56),
            child: Column(
              children: [
                TextFormField(
                  initialValue: widget.initialRecipe?.title,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter something.';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    title = value!;
                  },
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: 'Title',
                  ),
                ),
                SizedBox(height: fieldsMargin),
                TextFormField(
                  initialValue: widget.initialRecipe?.servings,
                  onSaved: (value) {
                    servings = value!;
                  },
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: 'Servings',
                  ),
                ),
                SizedBox(height: fieldsMargin),
                TextFormField(
                  initialValue: widget.initialRecipe?.ingredients,
                  onSaved: (value) {
                    ingredients = value!;
                  },
                  maxLines: 7,
                  keyboardType: TextInputType.multiline,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: 'Ingredients',
                  ),
                ),
                SizedBox(height: fieldsMargin),
                TextFormField(
                  initialValue: widget.initialRecipe?.steps,
                  onSaved: (value) {
                    steps = value!;
                  },
                  maxLines: 7,
                  keyboardType: TextInputType.multiline,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: 'Steps',
                  ),
                ),
                SizedBox(height: fieldsMargin),
                TextFormField(
                  validator: (value) {
                    if ((value ?? "").isNotEmpty &&
                        Uri.tryParse(value ?? "") == null) {
                      return "Please enter a valid URL";
                    }
                    return null;
                  },
                  initialValue: widget.initialRecipe?.source,
                  onSaved: (value) {
                    source = value ?? "";
                  },
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: 'Recipe source URL',
                  ),
                )
              ],
            ),
          ),
        )));
  }
}
