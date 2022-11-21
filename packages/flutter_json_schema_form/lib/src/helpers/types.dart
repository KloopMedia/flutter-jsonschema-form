import 'package:json_annotation/json_annotation.dart';

typedef WidgetOnChangeCallback<T> = void Function(T? value);
typedef WidgetValidator<T> = String? Function(T? value);

enum FieldType { object, array, string, number, integer, boolean }

enum WidgetType {
  radio,
  select,
  textarea,
  // audio,
  // link,
  // password,
  // email,
  // date,
  // dateTime,
  // file,
  // card,
  // reader,
  none,
}

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
  // WidgetType.audio: 'audio',
  // WidgetType.link: 'link',
  // WidgetType.password: 'password',
  // WidgetType.email: 'email',
  // WidgetType.date: 'date',
  // WidgetType.dateTime: 'datetime',
  // WidgetType.file: 'customfile',
  // WidgetType.card: 'card',
  // WidgetType.reader: 'reader',
};

FieldType decodeFieldType(String? type) => $enumDecodeNullable(typeEnumMap, type) ?? FieldType.string;

WidgetType decodeWidgetType(String? type) => $enumDecodeNullable(widgetEnumMap, type) ?? WidgetType.none;
