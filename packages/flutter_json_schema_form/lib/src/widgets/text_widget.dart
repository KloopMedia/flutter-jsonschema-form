import 'package:flutter/material.dart';

import '../helpers/helpers.dart';

class TextWidget extends StatelessWidget {
  final String? value;
  final bool textArea;
  final WidgetOnChangeCallback<String> onChange;

  const TextWidget({
    Key? key,
    required this.value,
    this.textArea = false,
    required this.onChange,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (textArea) {
      return TextFormField(
        initialValue: value,
        decoration: decoration,
        minLines: 4,
        maxLines: 10,
        onChanged: onChange,
      );
    }
    return TextFormField(
      initialValue: value,
      decoration: decoration,
      onChanged: onChange,
    );
  }
}
