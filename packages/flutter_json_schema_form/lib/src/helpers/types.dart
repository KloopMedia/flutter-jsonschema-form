import 'package:json_annotation/json_annotation.dart';

enum FieldType { object, array, string, number, integer, boolean }

enum WidgetType { radio, select, textarea }

const typeEnumMap = {
  FieldType.object: 'object',
  FieldType.array: 'array',
  FieldType.string: 'string',
  FieldType.number: 'number',
  FieldType.integer: 'integer',
  FieldType.boolean: 'boolean',
};

const widgetEnumMap = {
  WidgetType.select: 'select',
  WidgetType.textarea: 'textarea',
  WidgetType.radio: 'radio',
};

FieldType? decodeFieldType(String? type) => $enumDecodeNullable(typeEnumMap, type);

WidgetType? decodeWidgetType(String? type) => $enumDecodeNullable(widgetEnumMap, type);
