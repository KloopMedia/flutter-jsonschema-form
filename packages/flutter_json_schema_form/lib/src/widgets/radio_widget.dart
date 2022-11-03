import 'package:flutter/material.dart';

import '../helpers/helpers.dart';

class RadioWidget<T> extends StatefulWidget {
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
  State<RadioWidget<T>> createState() => _RadioWidgetState<T>();
}

class _RadioWidgetState<T> extends State<RadioWidget<T>> {
  late var currentValue = widget.value;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: List.generate(widget.items.length, (index) {
        final item = widget.items[index];
        return RadioListTile<T>(
          title: Text(item['name']),
          value: item['value'],
          groupValue: currentValue,
          contentPadding: EdgeInsets.zero,
          onChanged: (newValue) {
            setState(() {
              currentValue = newValue;
            });
            widget.onChange(newValue);
          },
        );
      }),
    );
  }
}
