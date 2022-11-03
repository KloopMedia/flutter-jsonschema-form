import 'package:flutter/material.dart';

import '../helpers/helpers.dart';
import 'models.dart';

class BooleanFieldModel extends BaseField {
  const BooleanFieldModel({
    required String id,
    String? title,
    String? description,
    WidgetType? widgetType,
    List? enumItems,
    List? enumNames,
    required PathModel path,
  }) : super(
          id: id,
          title: title,
          description: description,
          fieldType: FieldType.boolean,
          widgetType: widgetType,
          path: path,
          enumItems: widgetType == WidgetType.select || widgetType == WidgetType.radio
              ? const [true, false]
              : null,
          enumNames: widgetType == WidgetType.select || widgetType == WidgetType.radio
              ? enumNames ?? const ["Yes", "No"]
              : null,
        );

  BooleanFieldModel copyWith({String? id, PathModel? path}) {
    return BooleanFieldModel(
      id: id ?? this.id,
      title: title,
      description: description,
      widgetType: widgetType,
      path: path ?? this.path,
      enumItems: enumItems,
      enumNames: enumNames,
    );
  }

  List<DropdownMenuItem<bool>> get dropdownItems => getDropdownItems<bool>();
}
