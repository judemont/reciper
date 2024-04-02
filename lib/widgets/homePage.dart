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
  List<int> selectedRecipes = [];

  @override
  void initState() {
    loadRecipes();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Reciper"),
        centerTitle: true,
        actions: [
          if (selectedRecipes.isNotEmpty)
            IconButton(
                onPressed: () {
                  removeSelectedRecipes(selectedRecipes).then((value) {
                    loadRecipes();
                  });
                },
                icon: const Icon(Icons.delete)),
        ],
      ),
      floatingActionButton: NewRecipeButton(reloadRecipes: loadRecipes),
      body: SingleChildScrollView(
        child: RecipeListView(
          recipes: recipes,
          onRecipesSelectionUpdate: onRecipesSelectionUpdate,
          selectedRecipesID: selectedRecipes,
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

  Future<void> onRecipesSelectionUpdate(List<int> values) async {
    setState(() {
      selectedRecipes = values;
    });
  }

  Future<void> deleteRecipe(int id) async {
    DatabaseService.removeRecipe(id);
  }

  Future<void> removeSelectedRecipes(List<int> selectedRecipes) async {
    for (var recipeID in selectedRecipes) {
      deleteRecipe(recipeID);
    }
    setState(() {
      selectedRecipes = [];
    });
  }
}
