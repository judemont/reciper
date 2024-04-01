import 'package:flutter/material.dart';
import '../models/recipe.dart';

class RecipeViewPage extends StatefulWidget {
  final Recipe recipe;
  const RecipeViewPage({super.key, required this.recipe});

  @override
  State<RecipeViewPage> createState() => _RecipeViewPageState();
}

class _RecipeViewPageState extends State<RecipeViewPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Reciper"),
        centerTitle: true,
        actions: [IconButton(onPressed: () {}, icon: const Icon(Icons.edit))],
      ),
      body: Column(
        children: [
          Text(widget.recipe.title),
          Text(widget.recipe.ingredients),
          Text(widget.recipe.steps)
        ],
      ),
    );
  }
}
