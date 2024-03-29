import '../bloc/bloc.dart';
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
  bool delete = false,
  dynamic notSetValue,
  int i = 0,
  FieldType? parentType,
]) {
  if (i == keyPath.length) {
    return updater(data ?? notSetValue);
  }

  final field = keyPath[i];

  if (delete && keyPath.length == i + 1) {
    if (data is Map) {
      data.remove(field.id);
    }
    if (data is List) {
      var index = int.parse(field.id);
      data.removeAt(index);
    }
    return data;
  }

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
      delete,
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

bool shouldRebuildBloc(Field field, FormState previous, FormState current) {
  final previousValue = getFormDataByPath(previous.formData, field.path);
  final currentValue = getFormDataByPath(current.formData, field.path);
  final renderPreviousDependency = field.shouldRenderDependency(previous.formData);
  final renderCurrentDependency = field.shouldRenderDependency(current.formData);
  return renderPreviousDependency != renderCurrentDependency || previousValue != currentValue;
}
