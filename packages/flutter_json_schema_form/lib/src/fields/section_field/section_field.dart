import 'package:flutter/material.dart';

import '../../helpers/helpers.dart';
import '../../models/models.dart';
import '../../fields/fields.dart';

class SectionField extends StatefulWidget {
  final SectionModel model;

  const SectionField({Key? key, required this.model}) : super(key: key);

  @override
  State<SectionField> createState() => _SectionFieldState();
}

class _SectionFieldState extends State<SectionField> {
  @override
  Widget build(BuildContext context) {
    return FieldWrapper.section(
      title: widget.model.fieldTitle,
      description: widget.model.description,
      child: FormConstructor(
        fields: widget.model.fields,
        dependencies: widget.model.dependencies,
        order: widget.model.order,
      ),
    );
  }
}
