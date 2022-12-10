import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';

import '../helpers/helpers.dart';
import 'models.dart';

abstract class FieldModel {
  final String id;
  final String? title;
  final String? description;
  final FieldType fieldType;
  final WidgetModel widgetType;
  final PathModel path;
  final List? enumItems;
  final List? enumNames;
  final bool isRequired;
  final bool disabled;
  final bool readOnly;

  const FieldModel.init({
    required this.id,
    this.title,
    this.description,
    required this.fieldType,
    required widgetType,
    required this.path,
    this.enumItems,
    this.enumNames,
    required this.isRequired,
    required this.disabled,
    required this.readOnly,
  }): widgetType = widgetType is NullWidgetModel && enumItems != null ? const SelectWidgetModel() : widgetType;

  factory FieldModel({
    required String id,
    required PathModel path,
    String? title,
    String? description,
    required FieldType fieldType,
    required WidgetModel widgetType,
    List? enumItems,
    List? enumNames,
    bool isRequired = false,
    dynamic defaultValue,
    bool? disabled,
    bool? readOnly,
    FormatType? format,
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
          isRequired: isRequired,
          defaultValue: defaultValue,
          disabled: disabled,
          readOnly: readOnly,
          format: format,
        );
      case FieldType.number:
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
          isRequired: isRequired,
          defaultValue: defaultValue,
          disabled: disabled,
          readOnly: readOnly,
        );
      case FieldType.boolean:
        return BooleanFieldModel(
          id: id,
          title: title,
          description: description,
          widgetType: widgetType,
          enumNames: enumNames,
          path: path,
          isRequired: isRequired,
          defaultValue: defaultValue,
          disabled: disabled,
          readOnly: readOnly,
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
          isRequired: isRequired,
          defaultValue: defaultValue,
          disabled: disabled,
          readOnly: readOnly,
          format: format,
        );
    }
  }

  String get fieldTitle => title ?? id;

  dynamic copyWith({String? id, PathModel? path});

  List<DropdownMenuItem<T>> getDropdownItems<T>() {
    final options = enumItems ?? [];
    final names = enumNames ?? [];

    if (options.isEmpty) {
      return [];
    }

    List<DropdownMenuItem<T>> items = List.generate(options.length, (index) {
      final T value = _parseValue<T>(options[index]);

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
      final T value = _parseValue<T>(options[index]);
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

  List<FormBuilderFieldOption<T>> getRadio<T>() {
    final options = enumItems ?? [];
    final names = enumNames ?? [];

    if (options.isEmpty) {
      return [];
    }

    List<FormBuilderFieldOption<T>> items = List.generate(options.length, (index) {
      final T value = _parseValue<T>(options[index]);
      String name;
      try {
        name = names[index].toString();
      } catch (_) {
        name = value.toString();
      }
      return FormBuilderFieldOption(value: value, child: Text(name));
    });
    return items;
  }
}

T _parseValue<T>(dynamic value) {
  try {
    if (T == num) {
      return num.parse(value) as T;
    } else {
      return value;
    }
  } catch (e) {
    return null as T;
  }
}
