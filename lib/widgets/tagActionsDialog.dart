import 'package:flutter/material.dart';
import 'package:reciper/models/tag.dart';
import 'package:reciper/utilities/database.dart';

class TagActionDialog extends StatelessWidget {
  final Tag tag;
  const TagActionDialog({super.key, required this.tag});

  @override
  Widget build(BuildContext context) {
    TextEditingController newTagInputController =
        TextEditingController(text: tag.name);

    return AlertDialog(
        title: const Text("Tag options"),
        content: TextField(
          controller: newTagInputController,
          decoration: const InputDecoration(hintText: "Rename Tag"),
        ),
        actions: <Widget>[
          TextButton(
              child: const Text("cancel"),
              onPressed: () {
                Navigator.pop(context);
              }),
          TextButton(
              child: const Text("delete tag"),
              onPressed: () {
                DatabaseService.removeTag(tag.id!);
                Navigator.pop(context);
              }),
          TextButton(
            child: const Text("save"),
            onPressed: () {
              tag.name = newTagInputController.text;
              DatabaseService.updateTag(tag);

              Navigator.pop(context);
            },
          ),
        ]);
  }
}
