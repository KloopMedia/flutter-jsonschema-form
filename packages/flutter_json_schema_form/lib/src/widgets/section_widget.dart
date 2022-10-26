import 'package:flutter/material.dart';

import '../helpers/helpers.dart';
import '../models/models.dart';
import 'widgets.dart';

class SectionWidget extends StatefulWidget {
  final Section model;

  const SectionWidget({Key? key, required this.model}) : super(key: key);

  @override
  State<SectionWidget> createState() => _SectionWidgetState();
}

class _SectionWidgetState extends State<SectionWidget> {
  @override
  Widget build(BuildContext context) {
    return FieldWrapper.section(
      title: widget.model.fieldTitle,
      description: widget.model.description,
      child: FormBuilder(fields: widget.model.fields),
    );
  }
}
