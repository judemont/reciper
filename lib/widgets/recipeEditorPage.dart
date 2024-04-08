import 'package:flutter/material.dart';
import 'package:reciper/database.dart';
import 'package:reciper/models/recipe.dart';
import 'package:reciper/widgets/homePage.dart';

class RecipeEditorPage extends StatefulWidget {
  final String initialTitle;
  final String initialIngredients;
  final String initialSteps;
  final int? recipeID;
  const RecipeEditorPage(
      {super.key,
      this.initialTitle = "",
      this.initialIngredients = "",
      this.initialSteps = "",
      this.recipeID});

  @override
  State<RecipeEditorPage> createState() => _RecipeEditorPageState();
}

class _RecipeEditorPageState extends State<RecipeEditorPage> {
  final double fieldsMargin = 30.0;
  final formKey = GlobalKey<FormState>();
  String title = "";
  String ingredients = "";
  String steps = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: true,
        appBar: AppBar(
          title: const Text("New Recipe"),
          centerTitle: true,
          actions: [
            IconButton(
                onPressed: () {
                  if (formKey.currentState!.validate()) {
                    formKey.currentState!.save();
                    if (widget.recipeID == null) {
                      print("NEW RECIPE");
                      DatabaseService.createRecipe(Recipe(
                          title: title,
                          steps: steps,
                          ingredients: ingredients));
                    } else {
                      print("RECIPE UPDATE");
                      DatabaseService.updateRecipe(Recipe(
                          id: widget.recipeID,
                          title: title,
                          steps: steps,
                          ingredients: ingredients));
                    }

                    Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => HomePage()),
                    );
                  }
                },
                icon: const Icon(Icons.check))
          ],
        ),
        body: SingleChildScrollView(
            child: Form(
          key: formKey,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 56),
            child: Column(
              children: [
                TextFormField(
                  initialValue: widget.initialTitle,
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
                  initialValue: widget.initialIngredients,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter something.';
                    }
                    return null;
                  },
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
                  initialValue: widget.initialSteps,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter something.';
                    }
                    return null;
                  },
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
              ],
            ),
          ),
        )));
  }
}
