import 'package:flutter/material.dart';

import '../helpers/helpers.dart';
import 'models.dart';

abstract class FieldModel {
  final String id;
  final String? title;
  final String? description;
  final FieldType? fieldType;
  final WidgetType? widgetType;
  final PathModel path;
  final List? enumItems;
  final List? enumNames;

  const FieldModel.init({
    required this.id,
    this.title,
    this.description,
    this.fieldType,
    WidgetType? widgetType,
    required this.path,
    this.enumItems,
    this.enumNames,
  }) : widgetType = widgetType == null && enumItems != null ? WidgetType.select : widgetType;

  factory FieldModel({
    required String id,
    required PathModel path,
    String? title,
    String? description,
    FieldType? fieldType,
    WidgetType? widgetType,
    List? enumItems,
    List? enumNames,
  }) {
    switch (fieldType) {
      case FieldType.string:
        return TextFieldModel(
          id: id,
          title: title,
          description: description,
          widgetType: widgetType,
          enumItems: enumItems,
          enumNames: enumNames,
          path: path,
        );
      case FieldType.number:
        return NumberFieldModel(
          id: id,
          title: title,
          description: description,
          fieldType: fieldType,
          widgetType: widgetType,
          enumItems: enumItems,
          enumNames: enumNames,
          path: path,
        );
      case FieldType.integer:
        return NumberFieldModel(
          id: id,
          title: title,
          description: description,
          fieldType: fieldType,
          widgetType: widgetType,
          enumItems: enumItems,
          enumNames: enumNames,
          path: path,
        );
      case FieldType.boolean:
        return BooleanFieldModel(
          id: id,
          title: title,
          description: description,
          widgetType: widgetType,
          enumNames: enumNames,
          path: path,
        );
      default:
        return TextFieldModel(
          id: id,
          title: title,
          description: description,
          widgetType: widgetType,
          enumItems: enumItems,
          enumNames: enumNames,
          path: path,
        );
    }
  }

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

  List<Map<String, dynamic>> getRadioItems<T>() {
    final options = enumItems ?? [];
    final names = enumNames ?? [];

    if (options.isEmpty) {
      return [];
    }

    List<Map<String, dynamic>> items = List.generate(options.length, (index) {
      final T value = options[index];
      String name;
      try {
        name = names[index].toString();
      } catch (_) {
        name = value.toString();
      }
      return {'value': value, 'name': name};
    });
    return items;
  }
}
