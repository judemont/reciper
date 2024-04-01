import 'package:flutter/material.dart';
import 'newRecipePage.dart';

class NewRecipeButton extends StatefulWidget {
  final Function reloadRecipes;
  const NewRecipeButton({super.key, required this.reloadRecipes});

  @override
  State<NewRecipeButton> createState() => _NewRecipeButtonState();
}

class _NewRecipeButtonState extends State<NewRecipeButton> {
  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      child: const Icon(Icons.add),
      onPressed: () {
        Navigator.of(context)
            .push(
              MaterialPageRoute(builder: (context) => const NewRecipePage()),
            )
            .then((value) => widget.reloadRecipes());
      },
    );
  }
}
