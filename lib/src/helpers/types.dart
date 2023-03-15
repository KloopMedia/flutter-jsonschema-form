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

// const widgetEnumMap = {
//   'select': SelectWidgetModel,
//   'textarea': TextAreaWidgetModel,
//   'radio': RadioWidgetModel,
//   'audio': AudioWidgetModel,
//   'customlink': LinkWidgetModel,
//   'link': LinkWidgetModel,
//   'password': PasswordWidgetModel,
//   'customfile': FileWidgetModel,
//   'file': FileWidgetModel,
//   'recorder': RecorderWidgetModel,
//   'webhook': WebhookTriggerWidgetModel,
// };

const formatEnumMap = {
  FormatType.email: 'email',
  FormatType.uri: 'uri',
  FormatType.file: 'data-url',
  FormatType.date: 'date',
  FormatType.dateTime: 'date-time',
};
