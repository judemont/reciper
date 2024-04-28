import 'package:flutter/material.dart';
import 'package:reciper/models/tag.dart';
import 'package:reciper/widgets/newTagDialog.dart';

class RecipeTagSelector extends StatefulWidget {
  final List<Tag> tags;
  final List<int> selectedTagsId;

  final Function onTagsSelectionUpdate;
  final Function onTagsUpdate;

  const RecipeTagSelector(
      {super.key,
      required this.tags,
      required this.onTagsUpdate,
      required this.selectedTagsId,
      required this.onTagsSelectionUpdate});

  @override
  State<RecipeTagSelector> createState() => _RecipeTagSelectorState();
}

class _RecipeTagSelectorState extends State<RecipeTagSelector> {
  @override
  Widget build(BuildContext context) {
    return Row(children: [
      ListView.builder(
          itemCount: widget.tags.length,
          shrinkWrap: true,
          scrollDirection: Axis.horizontal,
          itemBuilder: ((context, index) {
            return FilledButton(
                style: FilledButton.styleFrom(
                    backgroundColor:
                        widget.selectedTagsId.contains(widget.tags[index].id)
                            ? Theme.of(context).colorScheme.primary
                            : Theme.of(context).colorScheme.secondary),
                // :
                //     ? Theme.of(context).primaryColor
                //     : Colors.transparent,
                child: Row(children: [
                  widget.selectedTagsId.contains(widget.tags[index].id)
                      ? const Icon(Icons.check)
                      : const Text(""),
                  Text(widget.tags[index].name ?? "")
                ]),
                onPressed: () {
                  bool value =
                      !widget.selectedTagsId.contains(widget.tags[index].id);
                  if (value) {
                    widget.selectedTagsId.add(widget.tags[index].id!);
                  } else {
                    widget.selectedTagsId.remove(widget.tags[index].id);
                  }
                  widget.onTagsSelectionUpdate(widget.selectedTagsId);
                  widget.onTagsUpdate(widget.tags);
                });
          })),
      IconButton(
          icon: const Icon(
            Icons.add,
          ),
          onPressed: () {
            showDialog(
                    context: context,
                    builder: (context) => const NewTagDialog())
                .then((value) => widget.onTagsUpdate());
          })
    ]);
  }
}

/*
 DropdownButton(
      onChanged: (value) {},
      items: widget.tags.map<DropdownMenuItem<String>>((Tag tag) {
        return DropdownMenuItem<String>(
          value: tag.id.toString(),
          child: Row(
            children: [
              Checkbox(
                  value: widget.selectedTagsId.contains(tag.id),
                  onChanged: (value) {
                    if (value ?? false) {
                      widget.selectedTagsId.add(tag.id!);
                    } else {
                      widget.selectedTagsId.remove(tag.id);
                    }
                    widget.onTagsSelectionUpdate(widget.selectedTagsId);
                    widget.onTagsUpdate(widget.tags);
                  }),
              Text(tag.name ?? "")
            ],
          ),
        );
      }).toList(),
    );
*/
