import 'package:flutter/cupertino.dart';

import '../models/models.dart';
import 'helpers.dart';

abstract class Field {
  final String id;
  final String? title;
  final String? description;
  final PathModel path;
  final PathModel? dependencyParentPath;
  final List<dynamic>? dependencyConditions;

  Field({
    required this.id,
    required this.path,
    this.title,
    this.description,
    this.dependencyParentPath,
    this.dependencyConditions,
  });

  bool get hasTitleOrDescription => title != null || description != null;

  bool get isDependent => dependencyConditions != null && dependencyParentPath != null;
}

class ValueField<T> extends Field {
  final T? defaultValue;
  final List<T>? enumValues;
  final List<String>? enumNames;
  final bool enabled;
  final bool required;
  final WidgetModel? widgetType;

  ValueField({
    required String id,
    required PathModel path,
    String? title,
    String? description,
    PathModel? dependencyParentPath,
    List<dynamic>? dependencyConditions,
    this.defaultValue,
    this.enumValues,
    this.enumNames,
    this.enabled = true,
    this.required = false,
    this.widgetType,
  }) : super(
          id: id,
          path: path,
          title: title,
          description: description,
          dependencyParentPath: dependencyParentPath,
          dependencyConditions: dependencyConditions,
        );
}

abstract class ComplexField extends Field {
  ComplexField({
    required String id,
    required PathModel path,
    String? title,
    String? description,
    PathModel? dependencyParentPath,
    List<dynamic>? dependencyConditions,
  }) : super(
          id: id,
          path: path,
          title: title,
          description: description,
          dependencyParentPath: dependencyParentPath,
          dependencyConditions: dependencyConditions,
        );
}

class Section extends ComplexField {
  final List<Field> fields;

  Section({
    required String id,
    required PathModel path,
    String? title,
    String? description,
    PathModel? dependencyParentPath,
    List<dynamic>? dependencyConditions,
    required this.fields,
  }) : super(
          id: id,
          path: path,
          title: title,
          description: description,
          dependencyParentPath: dependencyParentPath,
          dependencyConditions: dependencyConditions,
        );
}

abstract class ArrayField extends ComplexField {
  ArrayField({
    required String id,
    required PathModel path,
    String? title,
    String? description,
    PathModel? dependencyParentPath,
    List<dynamic>? dependencyConditions,
  }) : super(
          id: id,
          path: path,
          title: title,
          description: description,
          dependencyParentPath: dependencyParentPath,
          dependencyConditions: dependencyConditions,
        );
}

class FixedArray extends ArrayField {
  final List<Field> fields;

  FixedArray({
    required String id,
    required PathModel path,
    String? title,
    String? description,
    PathModel? dependencyParentPath,
    List<dynamic>? dependencyConditions,
    required this.fields,
  }) : super(
          id: id,
          path: path,
          title: title,
          description: description,
          dependencyParentPath: dependencyParentPath,
          dependencyConditions: dependencyConditions,
        );
}

class DynamicArray extends ArrayField {
  final Field field;

  DynamicArray({
    required String id,
    required PathModel path,
    String? title,
    String? description,
    PathModel? dependencyParentPath,
    List<dynamic>? dependencyConditions,
    required this.field,
  }) : super(
          id: id,
          path: path,
          title: title,
          description: description,
          dependencyParentPath: dependencyParentPath,
          dependencyConditions: dependencyConditions,
        );
}

FieldType getFieldType(Map<String, dynamic> schema) {
  final maybeObject = schema.containsKey("properties") ? "object" : null;
  return decodeFieldType(schema['type'] ?? maybeObject);
}

List<String> _getRequiredFields(Map<String, dynamic> schema) {
  if (schema.containsKey('required')) {
    return (schema['required'] as List<dynamic>).cast();
  } else {
    return [];
  }
}

List<Field> _parseObjectFields(
  Map<String, dynamic> properties,
  List<String> required,
  PathModel path, {
  Map<String, dynamic>? uiSchema,
  PathModel? dependencyParentPath,
  List<dynamic>? dependencyConditions,
}) {
  final List<Field> subFields = [];

  for (final entry in properties.entries) {
    final id = entry.key;
    final subSchema = entry.value;

    final subField = parseSchema(
      id: id,
      schema: subSchema,
      path: path,
      dependencyConditions: dependencyConditions,
      dependencyParentPath: dependencyParentPath,
      isRequired: required.contains(id),
      uiSchema: uiSchema?[id],
    );
    subFields.addAll(subField);
  }

  return subFields;
}

List<Field> _parseDependencyFields(
  Map<String, dynamic> dependencies,
  PathModel path, {
  Map<String, dynamic>? uiSchema,
}) {
  final List<Field> subFields = [];

  for (final entry in dependencies.entries) {
    final List<Map<String, dynamic>> variants = entry.value['oneOf'];
    for (final variant in variants) {
      final Map<String, dynamic> copy = Map.of(variant['properties']);
      final List<dynamic> conditions = copy.remove(entry.key)?['enum'] ?? [];
      final parentPath = path.add(entry.key, FieldType.object);
      final fullCopy = {...variant, "properties": copy};
      if (copy.isNotEmpty) {
        final parsedDependencies = parseSchema(
          schema: fullCopy,
          path: path,
          dependencyParentPath: parentPath,
          dependencyConditions: conditions,
          uiSchema: uiSchema,
        );
        final unwrappedDependencies = _unwrapDependencies(parsedDependencies);
        subFields.addAll(unwrappedDependencies);
      }
    }
  }

  return subFields;
}

List<Field> _unwrapDependencies(List<Field> fields) {
  final List<Field> newList = [];
  for (final field in fields) {
    if (field is Section) {
      newList.addAll(_unwrapDependencies(field.fields));
    } else {
      newList.add(field);
    }
  }
  return newList;
}

List<Field> parseSchema({
  String id = "#",
  required Map<String, dynamic> schema,
  Map<String, dynamic>? uiSchema,
  PathModel path = const PathModel.empty(),
  PathModel? dependencyParentPath,
  List<dynamic>? dependencyConditions,
  bool? isRequired,
}) {
  final type = getFieldType(schema);

  if (type == FieldType.object) {
    final newPath = id == "#" ? path : path.add(id, FieldType.object);

    final List<String> required = _getRequiredFields(schema);
    final objectFields = _parseObjectFields(
      schema['properties'],
      required,
      newPath,
      uiSchema: uiSchema,
      dependencyParentPath: dependencyParentPath,
      dependencyConditions: dependencyConditions,
    );

    List<Field> dependencyFields;
    if (schema['dependencies'] != null) {
      dependencyFields = _parseDependencyFields(
        schema['dependencies'],
        newPath,
        uiSchema: uiSchema,
      );
    } else {
      dependencyFields = [];
    }

    final subFields = [...objectFields, ...dependencyFields];

    return [
      Section(
        id: id,
        path: path,
        fields: subFields,
        dependencyConditions: dependencyConditions,
        dependencyParentPath: dependencyParentPath,
      ),
    ];
  } else {
    final newPath = path.add(id, FieldType.object);
    return [
      ValueField(
        id: id,
        path: newPath,
        dependencyParentPath: dependencyParentPath,
        dependencyConditions: dependencyConditions,
        required: isRequired ?? false,
        widgetType: WidgetModel.fromUiSchema(uiSchema),
      ),
    ];
  }
}

List<Widget> serializeFields(List<Field> fields, Map<String, dynamic> formData) {
  final List<Widget> serializedFields = [];

  for (final field in fields) {
    if (field is Section) {
      if (field.hasTitleOrDescription) {
        serializedFields.add(Text('${field.id} ${field.title}'));
      }
      if (field.isDependent) {
        final parentValue = getFormDataByPath(formData, field.dependencyParentPath!);
        if (field.dependencyConditions!.contains(parentValue)) {
          serializedFields.addAll(serializeFields(field.fields, formData));
        }
      } else {
        serializedFields.addAll(serializeFields(field.fields, formData));
      }
    } else if (field is FixedArray) {
      serializedFields.add(Text('${field.id} ${field.title}'));
      serializedFields.addAll(serializeFields(field.fields, formData));
    } else {
      if (field.isDependent) {
        final parentValue = getFormDataByPath(formData, field.dependencyParentPath!);
        if (field.dependencyConditions!.contains(parentValue)) {
          serializedFields.add(Text(field.id));
        }
      } else {
        serializedFields.add(Text(field.id));
      }
    }
  }

  return serializedFields;
}
