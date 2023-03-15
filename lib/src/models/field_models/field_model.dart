import 'package:flutter_json_schema_form/src/helpers/helpers.dart';
import 'package:flutter_json_schema_form/src/models/widget_models/null_widget_model.dart';

import '../models.dart';

abstract class FieldModel<Type> extends BaseModel {
  final WidgetModel widget;
  final List? enumItems;
  final List? enumNames;
  final bool isRequired;
  final bool disabled;
  final bool readOnly;
  final Type? defaultValue;

  FieldModel({
    required super.id,
    required super.fieldType,
    required super.path,
    required super.title,
    required super.description,
    required super.dependency,
    required this.enumItems,
    required this.enumNames,
    required this.isRequired,
    required this.disabled,
    required this.readOnly,
    required this.defaultValue,
    required WidgetModel widget,
  }) : widget = widget is NullWidgetModel && enumItems != null ? SelectWidgetModel() : widget;

  FieldModel.fromSchema({
    required super.id,
    required super.path,
    required super.dependency,
    required Map<String, dynamic> schema,
    required Map<String, dynamic>? uiSchema,
    required this.isRequired,
    required WidgetModel widget,
  })  : enumItems = schema['enum'],
        enumNames = schema['enumNames'],
        disabled = uiSchema?['ui:disabled'] ?? false,
        readOnly = uiSchema?['ui:readonly'] ?? false,
        defaultValue = schema['default'],
        widget = widget is NullWidgetModel && schema['enum'] != null ? SelectWidgetModel() : widget,
        assert(schema['default'] is Type?),
        super(
          title: schema['title'],
          description: schema['description'],
          fieldType: getFieldType(schema),
        );


  List<MapEntry<T, String>> getEnumItems<T>() {
    final options = enumItems ?? [];
    final names = enumNames ?? [];

    if (options.isEmpty) {
      return [];
    }

    return List.generate(options.length, (index) {
      final T value = _parseValue<T>(options[index]);
      String name;
      try {
        final enumName = names[index].toString();
        if (enumName.isNotEmpty) {
          name = enumName;
        } else {
          name = value.toString();
        }
      } catch (_) {
        name = value.toString();
      }
      return MapEntry<T, String>(value, name);
    });
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
