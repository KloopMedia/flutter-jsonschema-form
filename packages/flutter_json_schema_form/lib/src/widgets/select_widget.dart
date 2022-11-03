import 'package:flutter/material.dart';

import '../helpers/helpers.dart';

class SelectWidget<T> extends StatelessWidget {
  final T? value;
  final List<DropdownMenuItem<T>> items;
  final WidgetOnChangeCallback<T> onChange;

  const SelectWidget({
    Key? key,
    required this.value,
    required this.items,
    required this.onChange,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<T>(
      value: value,
      decoration: decoration,
      onChanged: onChange,
      items: items,
    );
  }
}
