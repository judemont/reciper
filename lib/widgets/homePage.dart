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
  bool selecting = false;

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
          if (selecting)
            IconButton(onPressed: () {}, icon: const Icon(Icons.delete)),
        ],
      ),
      floatingActionButton: NewRecipeButton(reloadRecipes: loadRecipes),
      body: SingleChildScrollView(
        child: RecipeListView(
          recipes: recipes,
          setSelecting: setSelecting,
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

  Future<void> setSelecting(bool value) async {
    setState(() {
      selecting = value;
    });
  }
}
