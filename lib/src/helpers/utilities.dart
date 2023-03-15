import 'package:intl/intl.dart';

import '../models/models.dart';
import 'helpers.dart';

FieldType getFieldType(Map<String, dynamic> schema) {
  return decodeFieldType(schema['type']);
}

List<String> getRequiredFields(Map<String, dynamic> schema) {
  if (schema.containsKey('required')) {
    return (schema['required'] as List<dynamic>).cast();
  } else {
    return [];
  }
}

List<String> getOrder(Map<String, dynamic>? uiSchema) {
  if (uiSchema == null || !uiSchema.containsKey('ui:order')) {
    return [];
  }
  return (uiSchema['ui:order'] as List<dynamic>).cast();
}

PathModel addPath(PathModel? path, String id, FieldType? type) {
  if (path == null) {
    return const PathModel.empty();
  } else {
    return path.add(id, type);
  }
}

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
