import 'package:flutter/material.dart';
import '../../fields/field_wrapper.dart';
import '../../models/card_field_model.dart';
import 'card_widget.dart';

class CardFormField extends StatelessWidget {
  final CardFieldModel model;

  const CardFormField({
    Key? key,
    required this.model,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FieldWrapper(
      title: model.title,
      description: model.description,
      isRequired: model.isRequired,
      child: CardWidget(model: model),
    );
  }
}
