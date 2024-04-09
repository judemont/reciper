import 'package:file_selector/file_selector.dart';
import 'package:flutter/material.dart';
import 'package:reciper/widgets/extractRecipeButton.dart';
import 'package:reciper/widgets/settings.dart';
import 'package:share_plus/share_plus.dart';
import 'newRecipeButton.dart';
import '../database.dart';
import '../models/recipe.dart';
import 'recipesListView.dart';
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
          restore: import,
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
    Directory appDocumentsDirectory =
        await getApplicationDocumentsDirectory(); // 1
    String appDocumentsPath = appDocumentsDirectory.path;
    String filePath = '$appDocumentsPath/Reciper_Export.json';

    File file = File(filePath);

    DatabaseService db = DatabaseService();
    db.export().then((String result) {
      file.writeAsString(result);
      Share.shareXFiles([XFile(filePath)]);
    });
  }

  Future<void> import() async {
    const XTypeGroup typeGroup = XTypeGroup(
      label: 'Reciper export',
      extensions: <String>['json'],
    );
    final XFile? file =
        await openFile(acceptedTypeGroups: <XTypeGroup>[typeGroup]);

    if (file != null) {
      String backupContent = await file.readAsString();
      DatabaseService db = DatabaseService();
      db.import(backupContent);
      loadRecipes();
    }
  }
}
