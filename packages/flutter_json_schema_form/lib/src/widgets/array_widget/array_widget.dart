import 'package:flutter/material.dart';

import '../../models/models.dart';
import '../widgets.dart';
import 'creatable_array.dart';
import 'fixed_array.dart';

class ArrayWidget extends StatefulWidget {
  final Array model;

  const ArrayWidget({Key? key, required this.model}) : super(key: key);

  @override
  State<ArrayWidget> createState() => _ArrayWidgetState();
}

class _ArrayWidgetState extends State<ArrayWidget> {
  @override
  Widget build(BuildContext context) {
    return FieldWrapper.section(
      title: widget.model.fieldTitle,
      description: widget.model.description,
      child: Builder(
        builder: (context) {
          if (widget.model.isFixed) {
            return FixedArray(items: widget.model.items!);
          } else {
            return CreatableArray(model: widget.model.itemType!);
          }
        },
      ),
    );
  }
}
