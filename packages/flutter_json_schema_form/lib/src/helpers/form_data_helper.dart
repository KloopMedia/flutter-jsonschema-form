import '../models/models.dart';
import 'helpers.dart';

Map<String, dynamic> updateFormDataByPath(
  Map<String, dynamic> formData,
  dynamic value,
  PathModel path,
) {
  dynamic data = {...formData};
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
  }
  return data;
}

dynamic getFormDataByPath(
  Map<String, dynamic> formData,
  PathModel path,
) {
  Map<String, dynamic> data = {...formData};
  final pathItems = path.path;
  dynamic dataPointer = data;
  for (final field in pathItems) {
    if (dataPointer is Map) {
      if (dataPointer.containsKey(field.id)) {
        dataPointer = dataPointer[field.id];
      } else {
        return null;
      }
    } else if (dataPointer is List) {
      try {
        final index = int.parse(field.id);
        dataPointer = dataPointer[index];
      } on RangeError {
        dataPointer = null;
      }
    } else {
      return dataPointer;
    }
  }
  return dataPointer;
}
