import 'package:flutter/material.dart';
import 'package:reciper/widgets/extract_recipe_dialog.dart';

class ExtractRecipeButton extends StatefulWidget {
  const ExtractRecipeButton({super.key});

  @override
  State<ExtractRecipeButton> createState() => _ExtractRecipeButtonState();
}

class _ExtractRecipeButtonState extends State<ExtractRecipeButton> {
  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      child: const Icon(Icons.add_link),
      onPressed: () => showDialog(
          context: context, builder: (context) => const ExtractRecipeDialog()),
    );
  }
}
