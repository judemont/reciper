import 'package:flutter/material.dart';
import 'package:reciper/widgets/extractRecipeButton.dart';
import 'package:reciper/widgets/settings.dart';
import 'package:share_plus/share_plus.dart';
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
        floatingActionButton: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            ExtractRecipeButton(reloadRecipes: loadRecipes),
            const SizedBox(height: 10),
            NewRecipeButton(reloadRecipes: loadRecipes),
          ],
        ),
        drawer: Drawer(
            child: Settings(
          backup: backup,
          restore: restore,
        )),
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

  Future<void> backup() async {
    DatabaseService db = DatabaseService();
    db.generateBackup().then((String result) {
      Share.share(result);
    });
  }

  Future<void> restore(String backup) async {
    DatabaseService db = DatabaseService();
    db.restoreBackup(backup);
    loadRecipes();
  }
}
