import 'package:flutter/material.dart';

import '../helpers/helpers.dart';
import 'models.dart';

abstract class BaseField {
  final String id;
  final String? title;
  final String? description;
  final FieldType? fieldType;
  final WidgetType? widgetType;
  final PathModel path;
  final List? enumItems;
  final List? enumNames;

  const BaseField({
    required this.id,
    this.title,
    this.description,
    this.fieldType,
    this.widgetType,
    required this.path,
    this.enumItems,
    this.enumNames,
  });

  String? get fieldTitle => title ?? id;

  List<DropdownMenuItem<T>> getDropdownItems<T>() {
    final options = enumItems ?? [];
    final names = enumNames ?? [];

    if (options.isEmpty) {
      return [];
    }

    List<DropdownMenuItem<T>> items = List.generate(options.length, (index) {
      final T value = options[index];
      String name;
      try {
        name = names[index].toString();
      } catch (_) {
        name = value.toString();
      }
      return DropdownMenuItem(value: value, child: Text(name));
    });
    return items;
  }
}
