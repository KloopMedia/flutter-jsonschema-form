import 'package:flutter/material.dart';

import '../helpers/helpers.dart';
import 'models.dart';

class TextFieldModel extends FieldModel {
  final String? defaultValue;
  const TextFieldModel({
    required String id,
    String? title,
    String? description,
    required WidgetModel widgetType,
    List? enumItems,
    List? enumNames,
    required bool isRequired,
    required PathModel path,
    this.defaultValue
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
    );
  }

  List<DropdownMenuItem<String>> get dropdownItems => getDropdownItems<String>();

  List<Map<String, dynamic>> get radioItems => getRadioItems<String>();
}
