import 'package:flutter/cupertino.dart';

import '../models/models.dart';
import 'helpers.dart';

abstract class Field {
  final String id;
  final String? title;
  final String? description;
  final PathModel path;
  final String? dependencyParentId;
  final PathModel? dependencyParentPath;
  final List<dynamic>? dependencyConditions;

  Field({
    required this.id,
    required this.path,
    this.title,
    this.description,
    this.dependencyParentId,
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
    required super.id,
    required super.path,
    super.title,
    super.description,
    super.dependencyParentId,
    super.dependencyParentPath,
    super.dependencyConditions,
    this.defaultValue,
    this.enumValues,
    this.enumNames,
    this.enabled = true,
    this.required = false,
    this.widgetType,
  });
}

abstract class ComplexField extends Field {
  ComplexField({
    required super.id,
    required super.path,
    super.title,
    super.description,
    super.dependencyParentId,
    super.dependencyParentPath,
    super.dependencyConditions,
  });
}

class Section extends ComplexField {
  final List<Field> fields;

  Section({
    required super.id,
    required super.path,
    super.title,
    super.description,
    super.dependencyParentId,
    super.dependencyParentPath,
    super.dependencyConditions,
    required this.fields,
  });
}

abstract class ArrayField extends ComplexField {
  ArrayField({
    required super.id,
    required super.path,
    super.title,
    super.description,
    super.dependencyParentId,
    super.dependencyParentPath,
    super.dependencyConditions,
  });
}

class FixedArray extends ArrayField {
  final List<Field> fields;

  FixedArray({
    required super.id,
    required super.path,
    super.title,
    super.description,
    super.dependencyParentId,
    super.dependencyParentPath,
    super.dependencyConditions,
    required this.fields,
  });
}

class DynamicArray extends ArrayField {
  final Field field;

  DynamicArray({
    required super.id,
    required super.path,
    super.title,
    super.description,
    super.dependencyParentId,
    super.dependencyParentPath,
    super.dependencyConditions,
    required this.field,
  });
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

List<String> getOrder(Map<String, dynamic>? uiSchema) {
  if (uiSchema == null || !uiSchema.containsKey('ui:order')) {
    return [];
  }
  return (uiSchema['ui:order'] as List<dynamic>).cast();
}

List<Field> _parseObjectFields(
  Map<String, dynamic> properties,
  List<String> required,
  PathModel path, {
  Map<String, dynamic>? uiSchema,
  String? dependencyParentId,
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
      dependencyParentId: dependencyParentId,
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
          dependencyParentId: entry.key,
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

List<Field> sortFields(
  List<Field> fields,
  List<Field> dependencies,
  List<String>? order,
) {
  if (order == null) {
    return fields;
  }
  final List<dynamic> allFields = [...fields, ...dependencies];
  final Map<String, List> fieldSchema = {};
  for (var field in allFields) {
    final schemaFields = fieldSchema[field.id] ?? [];
    fieldSchema[field.id] = [...schemaFields, field];
  }
  final other = fieldSchema.keys.where((element) => !order.contains(element));
  var orderSchema = List.of(order);
  if (order.contains('*')) {
    final wildCardIndex = order.indexOf('*');
    orderSchema.insertAll(wildCardIndex, other);
    orderSchema.remove('*');
  } else {
    orderSchema.addAll(other);
  }
  List<Field> sortedFields = [];
  for (var element in orderSchema) {
    final schemaFields = fieldSchema[element];
    if (schemaFields != null) {
      for (var field in schemaFields) {
        sortedFields.add(field);
      }
    }
  }
  for (var dependency in dependencies) {
    if (!order.contains(dependency.id)) {
      final index = fields.indexWhere((field) => field.path == dependency.dependencyParentPath);
      if (!index.isNegative) {
        sortedFields.insert(index + 1, dependency);
      }
    }
  }
  return sortedFields;
}

List<Field> parseSchema({
  String id = "#",
  required Map<String, dynamic> schema,
  Map<String, dynamic>? uiSchema,
  PathModel path = const PathModel.empty(),
  String? dependencyParentId,
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
      dependencyParentId: dependencyParentId,
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

    final order = getOrder(uiSchema);
    final subFields = sortFields(objectFields, dependencyFields, order);

    return [
      Section(
        id: id,
        path: path,
        fields: subFields,
        dependencyParentId: dependencyParentId,
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
        dependencyParentId: dependencyParentId,
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
