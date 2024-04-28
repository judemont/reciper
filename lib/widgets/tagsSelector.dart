import 'package:flutter/material.dart';
import 'package:reciper/models/tag.dart';
import 'package:reciper/utilities/database.dart';
import 'package:reciper/widgets/newTagDialog.dart';

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

  // @override
  // void initState() {
  //   super.initState();
  //   List<int> allTagIds = widget.tags.map((e) => e.id!).toList();
  //   widget.selectedTagsId.removeWhere((element) => true);
  //   widget.selectedTagsId.addAll(allTagIds);
  //   widget.onTagsSelectionUpdate(widget.selectedTagsId);
  // }

  @override
  Widget build(BuildContext context) {
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
            value: widget.selectedTagsId.length == widget.tags.length,
            secondary: const Icon(Icons.select_all),
            onChanged: (value) {
              setState(() {
                isAllChecked = value ?? false;
                if (isAllChecked) {
                  List<int> allTagIds = widget.tags.map((e) => e.id!).toList();
                  widget.selectedTagsId.clear();
                  widget.selectedTagsId.addAll(allTagIds);
                } else {
                  widget.selectedTagsId.clear();
                }
                widget.onTagsSelectionUpdate(widget.selectedTagsId);
              });
            },
          ),
          ListView.builder(
            shrinkWrap: true,
            itemCount: widget.tags.length,
            itemBuilder: (BuildContext context, int index) {
              return CheckboxListTile(
                value: widget.selectedTagsId.contains(widget.tags[index].id),
                title: Text(widget.tags[index].name ?? ""),
                onChanged: (value) {
                  setState(() {
                    if (value ?? false) {
                      widget.selectedTagsId.add(widget.tags[index].id!);
                    } else {
                      widget.selectedTagsId.remove(widget.tags[index].id);
                    }
                    widget.onTagsSelectionUpdate(widget.selectedTagsId);
                    widget.onTagsUpdate();
                  });
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
                      builder: (context) => const NewTagDialog())
                  .then((value) => widget.onTagsUpdate());
            },
          ),
        ],
      ),
    );
  }
}
