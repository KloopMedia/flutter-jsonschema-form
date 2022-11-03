import 'package:flutter/material.dart';

import '../helpers/helpers.dart';
import 'models.dart';

class TextFieldModel extends BaseField {
  const TextFieldModel({
    required String id,
    String? title,
    String? description,
    FieldType? fieldType,
    WidgetType? widgetType,
    List? enumItems,
    List? enumNames,
    required PathModel path,
  }) : super(
          id: id,
          title: title,
          description: description,
          fieldType: fieldType,
          widgetType: widgetType,
          path: path,
          enumItems: enumItems,
          enumNames: enumNames,
        );

  TextFieldModel copyWith({String? id, PathModel? path}) {
    return TextFieldModel(
      id: id ?? this.id,
      title: title,
      description: description,
      fieldType: fieldType,
      widgetType: widgetType,
      path: path ?? this.path,
      enumItems: enumItems,
      enumNames: enumNames,
    );
  }

  List<DropdownMenuItem<String>> get dropdownItems => getDropdownItems<String>();
}
