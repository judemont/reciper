import 'package:flutter/material.dart';
import 'package:reciper/models/tag.dart';
import 'package:reciper/utilities/database.dart';

class TagsSelector extends StatefulWidget {
  final List<Tag> tags;
  final List<int> selectedTagsId;

  final Function onTagsSelectionUpdate;
  final Function onTagsUpdate;

  const TagsSelector(
      {Key? key,
      required this.tags,
      required this.onTagsUpdate,
      required this.selectedTagsId,
      required this.onTagsSelectionUpdate})
      : super(key: key);

  @override
  State<TagsSelector> createState() => _TagsSelectorState();
}

class _TagsSelectorState extends State<TagsSelector> {
  bool isAllChecked = true;

  @override
  Widget build(BuildContext context) {
    TextEditingController newTagInputController = TextEditingController();

    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.secondary,
            ),
            child: const Text(
              'Tags',
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
              ),
            ),
          ),
          CheckboxListTile(
              title: const Text("All"),
              value: isAllChecked,
              secondary: Icon(Icons.all_inclusive),
              onChanged: (value) {
                setState(() {
                  isAllChecked = value ?? false;
                });
                if (isAllChecked) {
                  List<int> ids = widget.tags.map((e) => e.id!).toList();
                  // widget.selectedTagsId = ids;
                  widget.onTagsSelectionUpdate(ids);
                } else {
                  List<int> ids = [];
                  widget.onTagsSelectionUpdate(ids);
                  print("unchecked");
                }
              }),
          ListView.builder(
            shrinkWrap: true,
            itemCount: widget.tags.length,
            itemBuilder: (BuildContext context, int index) {
              return CheckboxListTile(
                value: widget.selectedTagsId.contains(widget.tags[index].id),
                title: Text(widget.tags[index].name ?? ""),
                onChanged: (value) {
                  if (value ?? false) {
                    widget.selectedTagsId.add(widget.tags[index].id!);
                  } else {
                    widget.selectedTagsId.remove(widget.tags[index].id);
                  }
                  widget.onTagsSelectionUpdate(widget.selectedTagsId);
                  widget.onTagsUpdate(widget.tags);
                },
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.add),
            title: const Text('New Tag'),
            onTap: () {
              showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                          title: const Text("New Tag"),
                          content: TextField(
                            controller: newTagInputController,
                            decoration:
                                const InputDecoration(hintText: "Tag name"),
                          ),
                          actions: <Widget>[
                            TextButton(
                              child: const Text("save"),
                              onPressed: () {
                                DatabaseService.createTag(
                                    Tag(name: newTagInputController.text));

                                widget.onTagsUpdate();
                                Navigator.pop(context);
                              },
                            )
                          ]));
            },
          ),
        ],
      ),
    );
  }
}
