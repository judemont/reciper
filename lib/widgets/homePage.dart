import 'package:flutter/material.dart';
import 'newRecipeButton.dart';
import '../database.dart';
import '../models/recipe.dart';
import 'recipesListView.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Recipe> recipes = [];

  @override
  void initState() {
    loadRecipes();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Reciper"),
        centerTitle: true,
      ),
      floatingActionButton: NewRecipeButton(reloadRecipes: loadRecipes),
      body: Container(
        margin: const EdgeInsets.only(left: 30),
        child: SingleChildScrollView(
          child: RecipeListView(
            recipes: recipes,
          ),
        ),
      ),
    );
  }

  Future<void> loadRecipes() async {
    DatabaseService.getRecipes().then((List<Recipe> result) {
      setState(() {
        print("recipes LOAD:");
        print(recipes);
        recipes = result;
      });
    });
  }
}
