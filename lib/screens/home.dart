import 'package:flutter/material.dart';
import 'package:reciper/models/tag.dart';
import 'package:reciper/widgets/tags_selector.dart';
import '../utilities/database.dart';
import '../models/recipe.dart';
import '../widgets/recipes_list.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Recipe> recipes = [];
  List<Tag> tags = [];

  List<int> selectedTagsId = [];
  List<int> selectedRecipes = [];
  bool displaySearchField = false;

  @override
  void initState() {
    loadRecipes();
    loadTags().then((value) {
      selectedTagsId.clear();
      selectedTagsId.addAll(tags.map((e) => e.id!).toList());
    });

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
                    loadRecipes();
                  });
                },
                icon: const Icon(Icons.search)),
            if (selectedRecipes.isNotEmpty)
              IconButton(
                  onPressed: () => showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                            title: const Text("Delete selected recipes"),
                            content: const Text("Are you sure?"),
                            actions: [
                              TextButton(
                                  onPressed: () => Navigator.pop(context),
                                  child: const Text("Cancel")),
                              TextButton(
                                  onPressed: () =>
                                      removeSelectedRecipes(selectedRecipes)
                                          .then((value) {
                                        loadRecipes();
                                        Navigator.pop(context);
                                      }),
                                  child: const Text("Yes")),
                            ],
                          )),
                  icon: const Icon(Icons.delete)),
          ],
        ),
        drawer: Drawer(
          child: TagsSelector(
              tags: tags,
              onTagsSelectionUpdate: onTagsSelectionUpdate,
              onTagsUpdate: loadTags,
              selectedTagsId: selectedTagsId),
        ),
        body: SingleChildScrollView(
            child: Column(
          children: [
            const SizedBox(
              height: 20,
            ),
            Visibility(
                visible: displaySearchField,
                child: SizedBox(
                    width: MediaQuery.of(context).size.width * 0.9,
                    child: TextField(
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: 'Search',
                      ),
                      onChanged: (value) {
                        loadRecipes(searchQuery: value);
                      },
                    ))),
            const SizedBox(
              height: 20,
            ),
            Visibility(
              visible: selectedTagsId.length != tags.length,
              child: ElevatedButton(
                child: const Text("Remove filters"),
                onPressed: () {
                  setState(() {
                    selectedTagsId.clear();
                    selectedTagsId.addAll(tags.map((e) => e.id!).toList());
                  });
                  loadRecipes();
                },
              ),
            ),
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
    if (selectedTagsId.length == tags.length) {
      DatabaseService.getRecipes(searchQuery: searchQuery)
          .then((List<Recipe> result) {
        setState(() {
          recipes = result;
        });
      });
    } else {
      setState(() {
        recipes = [];
      });

      for (var tagId in selectedTagsId) {
        DatabaseService.getRecipesFromTag(tagId, searchQuery: searchQuery)
            .then((values) {
          for (var recipe in values) {
            if (!recipes.contains(recipe)) {
              setState(() {
                recipes.add(recipe);
              });
            }
          }
        });
      }
    }
  }

  Future<void> loadTags() async {
    List<Tag> result = await DatabaseService.getTags();
    result.sort((a, b) => (a.name ?? "").compareTo(b.name ?? ""));
    setState(() {
      tags = result;
    });
  }

  Future<void> onTagsSelectionUpdate(List<int> values) async {
    print(values);
    setState(() {
      selectedTagsId = values;
    });
    loadRecipes();
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
