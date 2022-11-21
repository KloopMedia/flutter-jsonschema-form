import 'package:flutter/material.dart';

import '../helpers/helpers.dart';
import 'models.dart';

class TextFieldModel extends FieldModel {
  final String? defaultValue;

  const TextFieldModel({
    required String id,
    required String? title,
    required String? description,
    required WidgetModel widgetType,
    required List? enumItems,
    required List? enumNames,
    required bool isRequired,
    required PathModel path,
    required bool? disabled,
    required bool? readOnly,
    this.defaultValue,
  }) : super.init(
          id: id,
          title: title,
          description: description,
          fieldType: FieldType.string,
          widgetType: widgetType,
          path: path,
          enumItems: enumItems,
          enumNames: enumNames,
          isRequired: isRequired,
          disabled: disabled ?? false,
          readOnly: readOnly ?? false,
        );

  @override
  TextFieldModel copyWith({String? id, PathModel? path}) {
    return TextFieldModel(
      id: id ?? this.id,
      title: title,
      description: description,
      widgetType: widgetType,
      path: path ?? this.path,
      enumItems: enumItems,
      enumNames: enumNames,
      isRequired: isRequired,
      defaultValue: defaultValue,
      disabled: disabled,
      readOnly: readOnly,
    );
  }

  List<DropdownMenuItem<String>> get dropdownItems => getDropdownItems<String>();

  List<Map<String, dynamic>> get radioItems => getRadioItems<String>();
}
