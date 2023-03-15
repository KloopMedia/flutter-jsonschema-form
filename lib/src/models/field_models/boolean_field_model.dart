import 'package:flutter_json_schema_form/src/helpers/helpers.dart';

import '../models.dart';

class BooleanFieldModel extends FieldModel<bool> {
  BooleanFieldModel({
    required super.id,
    required super.path,
    required super.title,
    required super.description,
    required super.isRequired,
    required WidgetModel widget,
    required super.dependency,
    required super.disabled,
    required super.readOnly,
    required super.defaultValue,
    required List? enumNames,
  }) : super(
          fieldType: FieldType.boolean,
          widget: widget,
          enumItems: widget is SelectWidgetModel || widget is RadioWidgetModel
              ? const [true, false]
              : null,
          enumNames: widget is SelectWidgetModel || widget is RadioWidgetModel
              ? enumNames ?? const ["Yes", "No"]
              : null,
        );

  // @override
  // BooleanFieldModel copyWith({String? id, PathModel? path}) {
  //   return BooleanFieldModel(
  //     id: id ?? this.id,
  //     title: title,
  //     description: description,
  //     widgetType: widgetType,
  //     path: path ?? this.path,
  //     enumNames: enumNames,
  //     isRequired: isRequired,
  //     defaultValue: defaultValue,
  //     disabled: disabled,
  //     readOnly: readOnly,
  //   );
  // }

  @override
  copyWith({String? id, PathModel? path}) {
    // TODO: implement copyWith
    throw UnimplementedError();
  }
}
