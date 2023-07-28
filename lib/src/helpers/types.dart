import 'package:intl/intl.dart';

typedef WidgetOnChangeCallback<T> = void Function(T? value);
typedef WidgetValidator<T> = String? Function(T? value);

enum FieldType { object, array, string, number, integer, boolean }

enum WidgetType {
  radio,
  select,
  textarea,
  audio,
  link,
  password,
  file,
  card,
  reader,
  recorder,
  webhook,
  paragraph,
  autocomplete,
  none,
}

enum FormatType { email, uri, file, date, dateTime }

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
  WidgetType.audio: 'audio',
  WidgetType.link: ['customlink', 'link'],
  WidgetType.password: 'password',
  WidgetType.file: ['customfile', 'file'],
  WidgetType.card: 'card',
  WidgetType.reader: 'reader',
  WidgetType.recorder: 'recorder',
  WidgetType.webhook: 'webhook',
  WidgetType.paragraph: 'paragraph',
  WidgetType.autocomplete: 'simple_autocomplete'
};

const formatEnumMap = {
  FormatType.email: 'email',
  FormatType.uri: 'uri',
  FormatType.file: 'data-url',
  FormatType.date: 'date',
  FormatType.dateTime: 'date-time',
};

K? enumDecodeNullable<K extends Enum, V>(Map<K, V> enumValues, Object? source) {
  if (source == null) {
    return null;
  }

  for (var entry in enumValues.entries) {
    final value = entry.value;
    if (value is List) {
      if (value.contains(source)) {
        return entry.key;
      }
    }
    if (entry.value == source) {
      return entry.key;
    }
  }

  return null;
}

FieldType decodeFieldType(String? type) =>
    enumDecodeNullable(typeEnumMap, type) ?? FieldType.string;

WidgetType decodeWidgetType(String? type) =>
    enumDecodeNullable(widgetEnumMap, type) ?? WidgetType.none;

FormatType? decodeFormatType(String? type) => enumDecodeNullable(formatEnumMap, type);

DateTime? parseDateTime(String? value, String format) {
  if (value == null) {
    return null;
  }
  try {
    return DateFormat(format).parse(value);
  } on FormatException {
    return null;
  }
}