import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:reciper/models/tag.dart';
import 'package:reciper/utilities/database.dart';

class NewTagDialog extends StatelessWidget {
  const NewTagDialog({super.key});

  @override
  Widget build(BuildContext context) {
    TextEditingController newTagInputController = TextEditingController();

    return AlertDialog(
        title: const Text("New Tag"),
        content: TextField(
          controller: newTagInputController,
          decoration: const InputDecoration(hintText: "Tag name"),
        ),
        actions: <Widget>[
          TextButton(
              child: const Text("cancel"),
              onPressed: () {
                Navigator.pop(context);
              }),
          TextButton(
            child: const Text("save"),
            onPressed: () {
              DatabaseService.createTag(Tag(name: newTagInputController.text));

              Navigator.pop(context);
            },
          ),
        ]);
  }
}
