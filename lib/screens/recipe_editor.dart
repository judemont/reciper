import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:reciper/models/tag.dart';
import 'package:reciper/screens/pages_layout.dart';
import 'package:reciper/utilities/database.dart';
import 'package:reciper/models/recipe.dart';
import 'package:reciper/screens/home.dart';
import 'package:reciper/widgets/extract_recipe_button.dart';
import 'package:reciper/widgets/recipe_tag_selector.dart';

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
  String image = "";

  List<Tag> tags = [];
  List<int> selectedTagsId = [];

  @override
  void initState() {
    print(widget.initialRecipe);
    loadTags();
    if (widget.initialRecipe != null) {
      if (widget.initialRecipe?.id != null) {
        DatabaseService.getTagsFromRecipe(widget.initialRecipe!.id!)
            .then((tags) {
          selectedTagsId = tags.map((e) => e.id!).toList();
        });
      }
      image = widget.initialRecipe?.image ?? "";
    }
    super.initState();
  }

  Future<void> saveImage(XFile selectedImage) async {
    List<int> imageBytes = await selectedImage.readAsBytes();
    setState(() {
      image = base64Encode(imageBytes);
    });
  }

  Future<void> selectImage() async {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext context) {
          return Container(
            // height: 200,
            child: ListView(
              children: [
                ListTile(
                    leading: Icon(Icons.camera),
                    title: Text("Take a picture"),
                    onTap: () async {
                      final ImagePicker picker = ImagePicker();
                      final XFile? selectedImageX =
                          await picker.pickImage(source: ImageSource.camera);

                      if (selectedImageX != null) {
                        await saveImage(selectedImageX);
                        if (context.mounted) Navigator.pop(context);
                      }
                    }),
                ListTile(
                  leading: Icon(Icons.image),
                  title: Text("Select an image"),
                  onTap: () async {
                    final ImagePicker picker = ImagePicker();
                    final XFile? selectedImageX =
                        await picker.pickImage(source: ImageSource.gallery);

                    if (selectedImageX != null) {
                      await saveImage(selectedImageX);
                      if (context.mounted) Navigator.pop(context);
                    }
                  },
                )
              ],
            ),
          );
        });
  }

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
                        source: source,
                        image: image.isNotEmpty ? image : null,
                      )).then((recipeId) {
                        for (var tagId in selectedTagsId) {
                          DatabaseService.createTagLink(tagId, recipeId);
                        }
                      });
                    } else {
                      DatabaseService.removeTagLink(
                              recipeId: widget.initialRecipe!.id)
                          .then((value) {
                        for (var tagId in selectedTagsId) {
                          DatabaseService.createTagLink(
                              tagId, widget.initialRecipe!.id!);
                        }
                      });
                      DatabaseService.updateRecipe(Recipe(
                        id: widget.initialRecipe!.id,
                        servings: servings,
                        title: title,
                        steps: steps,
                        ingredients: ingredients,
                        source: source,
                        image: image.isNotEmpty ? image : null,
                      ));
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
                SizedBox(
                    height: 50,
                    child: Row(
                      children: [
                        const Text("Tags : "),
                        const SizedBox(
                          width: 20,
                        ),
                        RecipeTagSelector(
                            tags: tags,
                            onTagsUpdate: loadTags,
                            selectedTagsId: selectedTagsId,
                            onTagsSelectionUpdate: onTagsSelectionUpdate)
                      ],
                    )),
                SizedBox(height: fieldsMargin),
                image.isEmpty
                    ? ElevatedButton(
                        onPressed: () {
                          selectImage();
                        },
                        child: const Text("Add Image"))
                    : Column(children: [
                        Image.memory(Base64Decoder().convert(image)),
                        SizedBox(height: fieldsMargin),
                        ElevatedButton(
                            onPressed: () {
                              setState(() {
                                image = "";
                              });
                            },
                            child: const Text("Remove Image"))
                      ]),
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

  Future<void> loadTags() async {
    DatabaseService.getTags().then((List<Tag> result) {
      setState(() {
        tags = result;
        tags.sort((a, b) => (a.name ?? "").compareTo(b.name ?? ""));
      });
    });
  }

  Future<void> onTagsSelectionUpdate(List<int> values) async {
    setState(() {
      selectedTagsId = values;
    });
  }
}
