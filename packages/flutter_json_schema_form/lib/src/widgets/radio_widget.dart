import 'package:flutter/material.dart';

import '../helpers/helpers.dart';

class RadioWidget<T> extends StatelessWidget {
  final T? value;
  final List<Map<String, dynamic>> items;
  final WidgetOnChangeCallback<T> onChange;

  const RadioWidget({
    Key? key,
    required this.value,
    required this.items,
    required this.onChange,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: List.generate(items.length, (index) {
        final item = items[index];
        return RadioListTile<T>(
          title: Text(item['name']),
          value: item['value'],
          groupValue: value,
          contentPadding: EdgeInsets.zero,
          onChanged: onChange,
        );
      }),
    );
  }
}
