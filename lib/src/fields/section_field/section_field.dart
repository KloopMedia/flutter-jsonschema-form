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
  late final title = widget.model.fieldTitle == '#' ? null : widget.model.fieldTitle;
  late final description = widget.model.description;
  late final fields = widget.model.fields;

  @override
  Widget build(BuildContext context) {
    return FieldWrapper.section(
      title: title,
      description: description,
      child: FormConstructor(
        fields: fields,
      ),
    );
  }
}
