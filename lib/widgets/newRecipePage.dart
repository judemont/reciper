import 'package:flutter/material.dart';
import 'package:reciper/database.dart';
import 'package:reciper/models/recipe.dart';

class NewRecipePage extends StatefulWidget {
  const NewRecipePage({super.key});

  @override
  State<NewRecipePage> createState() => _NewRecipePageState();
}

class _NewRecipePageState extends State<NewRecipePage> {
  final double fieldsMargin = 30.0;
  final formKey = GlobalKey<FormState>();
  String title = "";
  String ingredients = "";
  String steps = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("New Recipe"),
          centerTitle: true,
          actions: [
            IconButton(
                onPressed: () {
                  if (formKey.currentState!.validate()) {
                    formKey.currentState!.save();
                    DatabaseService.createRecipe(Recipe(
                        title: title, steps: steps, ingredients: ingredients));
                    Navigator.pop(context);
                  }
                },
                icon: const Icon(Icons.check))
          ],
        ),
        body: Form(
          key: formKey,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 56),
            child: Column(
              children: [
                TextFormField(
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
        ));
  }
}
