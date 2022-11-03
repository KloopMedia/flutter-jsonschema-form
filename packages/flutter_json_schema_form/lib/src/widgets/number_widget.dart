import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../helpers/helpers.dart';

class NumberWidget<T> extends StatelessWidget {
  final String? value;
  final WidgetOnChangeCallback<T> onChange;

  const NumberWidget({
    Key? key,
    required this.value,
    required this.onChange,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      initialValue: value,
      decoration: decoration,
      keyboardType: TextInputType.number,
      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
      onChanged: (value) {
        if (T == int) {
          onChange(int.tryParse(value) as T?);
        }
        if (T == double) {
          onChange(double.tryParse(value) as T?);
        }
      },
    );
  }
}
