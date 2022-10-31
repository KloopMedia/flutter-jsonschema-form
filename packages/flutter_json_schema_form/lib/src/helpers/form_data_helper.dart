import 'package:flutter_json_schema_form/src/models/field.dart';

import 'helpers.dart';

Map<String, dynamic> updateFormDataByPath(
  Map<String, dynamic> formData,
  dynamic value,
  PathModel path,
) {
  Map<String, dynamic> data = {...formData};
  final pathItems = path.path;
  dynamic dataPointer = data;
  for (final field in pathItems) {
    if (field.fieldType == FieldType.object || field.fieldType == FieldType.array) {
      final emptyValue = field.fieldType == FieldType.object ? {} : [];
      if (dataPointer is Map) {
        dataPointer.putIfAbsent(field.id, () => emptyValue);
      }
      if (dataPointer is List) {
        dataPointer.add(emptyValue);
      }
    } else {
      if (dataPointer is Map) {
        dataPointer.update(field.id, (prevValue) => value, ifAbsent: () => value);
      }
      if (dataPointer is List) {
        final index = int.parse(field.id);
        try {
          dataPointer[index] = value;
        } on RangeError {
          for (var i = dataPointer.length; i < index; i++) {
            dataPointer.add(null);
          }
          dataPointer.add(value);
        }
      }
    }
    if (dataPointer is Map) {
      dataPointer = dataPointer[field.id];
    }
  }
  return data;
}
