import 'package:flutter/material.dart';

import '../../models/models.dart';
import '../../fields/fields.dart';
import 'dynamic_array.dart';
import 'static_array.dart';

class ArrayField extends StatelessWidget {
  final ArrayModel model;

  const ArrayField({Key? key, required this.model}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FieldWrapper.section(
      title: model.fieldTitle,
      description: model.description,
      child: Builder(
        builder: (context) {
          if (model is StaticArrayModel) {
            final items = (model as StaticArrayModel).items;
            return StaticArray(items: items);
          } else {
            return DynamicArray(model: model as DynamicArrayModel);
          }
        },
      ),
    );
  }
}
