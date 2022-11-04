import '../models/models.dart';
import 'helpers.dart';

Map<String, dynamic> updateFormDataByPath(
  Map<String, dynamic> formData,
  dynamic value,
  PathModel path,
) {
  final data = Map.of(formData);
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

// Original creator: marioreggiori (2022) Deeply (Version 1.2.0) [https://github.com/marioreggiori/deeply.dart].
dynamic updateDeeply(
  List<PathItem> keyPath,
  dynamic data,
  Function updater, [
  dynamic notSetValue,
  int i = 0,
  FieldType? parentType,
]) {
  if (i == keyPath.length) {
    return updater(data ?? notSetValue);
  }

  final field = keyPath[i];

  if (data == null) {
    if (parentType == FieldType.object) {
      data = {};
    }
    if (parentType == FieldType.array) {
      data = [];
    }
  }

  if (data is List) {
    try {
      var index = int.parse(field.id);
      data[index] = (updater(data));
    } on RangeError {
      data.add(updater(data));
    }
  } else {
    data = Map<dynamic, dynamic>.from(data);
    data[field.id] = updateDeeply(
      keyPath,
      data[field.id],
      updater,
      notSetValue,
      ++i,
      field.fieldType,
    );
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
