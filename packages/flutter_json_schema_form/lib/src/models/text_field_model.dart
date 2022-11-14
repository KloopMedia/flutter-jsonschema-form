import 'package:flutter/material.dart';

import '../helpers/helpers.dart';
import 'models.dart';

class TextFieldModel extends FieldModel {
  const TextFieldModel({
    required String id,
    String? title,
    String? description,
    WidgetType? widgetType,
    List? enumItems,
    List? enumNames,
    required bool isRequired,
    required PathModel path,
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
    );
  }

  List<DropdownMenuItem<String>> get dropdownItems => getDropdownItems<String>();

  List<Map<String, dynamic>> get radioItems => getRadioItems<String>();
}
