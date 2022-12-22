import 'package:flutter/material.dart';
import '../../../core/localization/transulation_constants.dart';
import '../../../core/models/tag_model.dart';

class TagsList extends StatelessWidget {

  /// The [tags] list to be rendered to this widget
  final List<Tag> tags;

  TagsList({@required this.tags});

  @override
  Widget build(BuildContext context) {
    return Wrap(
      children: tags.map((tag) {
        return Container(
          padding: const EdgeInsets.symmetric(
            vertical: 4,
            horizontal: 10,
          ),
          margin: EdgeInsets.only(
            left: isRTL(context) ? 5 : 0,
            bottom: 10,
            right: !isRTL(context) ? 5 : 0,
          ),
          decoration: BoxDecoration(
            color: Colors.black12,
            borderRadius: BorderRadius.circular(30),
          ),
          child: Text(
            tag.name,
            style: TextStyle(
              fontSize: 13,
              color: Colors.black,
            ),
          ),
        );
      }).toList(),
    );
  }
}
