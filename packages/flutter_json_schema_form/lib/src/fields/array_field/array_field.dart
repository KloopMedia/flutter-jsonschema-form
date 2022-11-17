import 'package:flutter/material.dart';

import '../../models/models.dart';
import '../../fields/fields.dart';
import 'creatable_array.dart';
import 'fixed_array.dart';

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
          if (model.isFixed) {
            return FixedArray(items: model.items!);
          } else {
            return CreatableArray(model: model);
          }
        },
      ),
    );
  }
}
