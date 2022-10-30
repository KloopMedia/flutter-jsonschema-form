import 'package:flutter/material.dart';

import '../helpers/helpers.dart';
import 'models.dart';

class TextFieldModel extends Field {
  List? enumOptions;
  List? enumNames;

  TextFieldModel({
    required String id,
    String? title,
    String? description,
    FieldType? fieldType,
    WidgetType? widgetType,
    this.enumOptions,
    this.enumNames,
    required Path path,
  }) : super(
          id: id,
          title: title,
          description: description,
          fieldType: fieldType,
          widgetType: widgetType,
          path: path,
        );

  List<DropdownMenuItem<String>> get dropdownItems {
    final options = enumOptions ?? [];
    final names = enumNames ?? [];

    if (options.isEmpty) {
      return [];
    }

    List<DropdownMenuItem<String>> menuItems = List.generate(options.length, (index) {
      final value = options[index];
      late final String name;
      try {
        name = names[index];
      } catch (_) {
        name = value;
      }
      return DropdownMenuItem(value: value, child: Text(name));
    });
    return menuItems;
  }
}
