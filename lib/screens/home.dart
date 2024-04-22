import 'package:file_selector/file_selector.dart';
import 'package:flutter/material.dart';
import 'package:reciper/widgets/extract_recipe_button.dart';
import 'package:reciper/screens/settings.dart';
import 'package:share_plus/share_plus.dart';
import '../utilities/database.dart';
import '../models/recipe.dart';
import '../widgets/recipes_list.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Recipe> recipes = [];
  List<int> selectedRecipes = [];
  bool displaySearchField = false;

  @override
  void initState() {
    loadRecipes();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: const Text("Reciper"),
          centerTitle: true,
          actions: [
            IconButton(
                onPressed: () {
                  setState(() {
                    displaySearchField = !displaySearchField;
                  });
                },
                icon: const Icon(Icons.search)),
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
        // drawer: Drawer(
        //     child: Settings(
        //   backup: backup,
        //   restore: import,
        // )),
        body: SingleChildScrollView(
            child: Column(
          children: [
            Visibility(
                visible: displaySearchField,
                child: TextField(
                  onChanged: (value) {
                    loadRecipes(searchQuery: value);
                  },
                )),
            RecipeListView(
              reloadRecipes: loadRecipes,
              recipes: recipes,
              onRecipesSelectionUpdate: onRecipesSelectionUpdate,
              selectedRecipesID: selectedRecipes,
            ),
          ],
        )));
  }

  Future<void> loadRecipes({searchQuery = ""}) async {
    DatabaseService.getRecipes(searchQuery: searchQuery)
        .then((List<Recipe> result) {
      setState(() {
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

  Future<void> removeSelectedRecipes(List<int> values) async {
    for (var recipeID in values) {
      deleteRecipe(recipeID);
    }
    setState(() {
      selectedRecipes = [];
    });
  }
}
