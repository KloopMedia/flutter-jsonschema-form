import 'package:flutter/material.dart';
import '../../fields/field_wrapper.dart';
import '../../models/models.dart';
import 'reader_widget.dart';

class ReaderFormField extends StatelessWidget {
  final ReaderFieldModel model;
  final dynamic value;

  const ReaderFormField({
    Key? key,
    required this.model,
    required this.value,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FieldWrapper(
      title: model.title,
      description: model.description,
      isRequired: model.isRequired,
      child: ReaderWidget(model: model, value: value),
    );
  }
}