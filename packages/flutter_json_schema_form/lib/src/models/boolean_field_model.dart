import 'package:flutter/material.dart';

import '../helpers/helpers.dart';
import 'models.dart';

class BooleanFieldModel extends FieldModel {
  final bool? defaultValue;

  const BooleanFieldModel({
    required String id,
    required String? title,
    required String? description,
    required WidgetModel widgetType,
    required List? enumNames,
    required PathModel path,
    required bool isRequired,
    required bool? disabled,
    required bool? readOnly,
    this.defaultValue,
  }) : super.init(
          id: id,
          title: title,
          description: description,
          fieldType: FieldType.boolean,
          widgetType: widgetType,
          path: path,
          isRequired: isRequired,
          disabled: disabled ?? false,
          readOnly: readOnly ?? false,
          enumItems:
              widgetType is SelectModel || widgetType is RadioModel ? const [true, false] : null,
          enumNames: widgetType is SelectModel || widgetType is RadioModel
              ? enumNames ?? const ["Yes", "No"]
              : null,
        );

  @override
  BooleanFieldModel copyWith({String? id, PathModel? path}) {
    return BooleanFieldModel(
      id: id ?? this.id,
      title: title,
      description: description,
      widgetType: widgetType,
      path: path ?? this.path,
      enumNames: enumNames,
      isRequired: isRequired,
      defaultValue: defaultValue,
      disabled: disabled,
      readOnly: readOnly,
    );
  }

  List<DropdownMenuItem<bool>> get dropdownItems => getDropdownItems<bool>();
}
