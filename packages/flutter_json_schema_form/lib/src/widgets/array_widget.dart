import 'package:flutter/material.dart';

import '../helpers/helpers.dart';
import '../models/models.dart';
import 'widgets.dart';

class ArrayWidget extends StatefulWidget {
  final Array model;

  const ArrayWidget({Key? key, required this.model}) : super(key: key);

  @override
  State<ArrayWidget> createState() => _ArrayWidgetState();
}

class _ArrayWidgetState extends State<ArrayWidget> {
  List<Field> fields = [];

  void addItemToArray() {
    final field = widget.model.itemType!;
    field.setId = fields.length.toString();
    setState(() {
      fields.add(field);
    });
  }

  void removeItemFromArray() {
    setState(() {
      fields.removeLast();
    });
  }

  @override
  Widget build(BuildContext context) {
    Widget child;
    if (widget.model.isFixed) {
      child = FormBuilder(fields: widget.model.items!);
    } else {
      child = Column(
        children: [
          FormBuilder(fields: fields),
          Row(
            children: [
              ElevatedButton(
                onPressed: addItemToArray,
                child: const Text('+'),
              ),
              ElevatedButton(
                onPressed: fields.isNotEmpty ? removeItemFromArray : null,
                child: const Text('-'),
              ),
            ],
          )
        ],
      );
    }
    return FieldWrapper.section(
      title: widget.model.fieldTitle,
      description: widget.model.description,
      child: child,
    );
  }
}
