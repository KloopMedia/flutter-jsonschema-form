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
}

class ValueField<T> extends Field {
  final T? defaultValue;
  final List<T>? enumValues;
  final List<String>? enumNames;
  final bool enabled;
  final bool required;

  ValueField({
    required super.id,
    required super.path,
    super.title,
    super.description,
    super.dependencyParentPath,
    super.dependencyConditions,
    this.defaultValue,
    this.enumValues,
    this.enumNames,
    this.enabled = true,
    this.required = false,
  });
}

class Header {
  final String? title;
  final String? description;

  Header({required this.title, required this.description});
}

abstract class ComplexField extends Field {
  ComplexField({
    required super.id,
    required super.path,
    super.title,
    super.description,
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
    super.dependencyParentPath,
    super.dependencyConditions,
    required this.field,
  });
}

class SchemaParser {
  final Map<String, dynamic> schema;
  final Map<String, dynamic>? uiSchema;
  final Map<String, dynamic> formData;

  const SchemaParser({required this.schema, this.uiSchema, required this.formData});

  static FieldType getFieldType(Map<String, dynamic> schema) {
    final maybeObject = schema.containsKey("properties") ? "object" : null;
    return decodeFieldType(schema['type'] ?? maybeObject);
  }

  // List<Field> _parseObject(Map<String, dynamic> properties, PathModel path) {
  //
  // }

  List<Field> parse({
    String id = "#",
    required Map<String, dynamic> schema,
    PathModel path = const PathModel.empty(),
    PathModel? dependencyParentPath,
    List<dynamic>? dependencyConditions,
  }) {
    final type = getFieldType(schema);
    final List<Field> fields = [];

    if (type == FieldType.object) {
      final Map<String, dynamic> properties = schema['properties'];
      final List<Field> subFields = [];
      final newPath = id == "#" ? path : path.add(id, FieldType.object);

      for (final entry in properties.entries) {
        final subField = parse(
          id: entry.key,
          schema: entry.value,
          path: newPath,
          dependencyConditions: dependencyConditions,
          dependencyParentPath: dependencyParentPath,
        );
        subFields.addAll(subField);
      }

      final Map<String, dynamic> dependencies = schema['dependencies'] ?? {};
      for (final entry in dependencies.entries) {
        final List<Map<String, dynamic>> variants = entry.value['oneOf'];
        for (final variant in variants) {
          final Map<String, dynamic> copy = Map.of(variant['properties']);
          final List<dynamic> conditions = copy.remove(entry.key)?['enum'] ?? [];
          final parentPath = newPath.add(entry.key, FieldType.object);
          final fullCopy = {...variant, "properties": copy};
          if (copy.isNotEmpty) {
            final depFields = parse(
              schema: fullCopy,
              path: newPath,
              dependencyParentPath: parentPath,
              dependencyConditions: conditions,
            );
            subFields.addAll(depFields);
          }
        }
      }

      fields.add(Section(
        id: id,
        path: path,
        fields: subFields,
        dependencyConditions: dependencyConditions,
        dependencyParentPath: dependencyParentPath,
      ));
    } else {
      final newPath = path.add(id, FieldType.object);
      fields.add(ValueField(
        id: id,
        path: newPath,
        dependencyParentPath: dependencyParentPath,
        dependencyConditions: dependencyConditions,
      ));
    }
    return fields;
  }

  List<Widget> serialize(List<Field> fields) {
    final List<Widget> _fields = [];
    for (final field in fields) {
      if (field is Section) {
        if (field.title != null || field.description != null) {
          _fields.add(Text('${field.id} ${field.title}'));
        }
        if (field.dependencyConditions != null && field.dependencyParentPath != null) {
          final parentValue = getFormDataByPath(formData, field.dependencyParentPath!);
          if (field.dependencyConditions!.contains(parentValue)) {
            _fields.addAll(serialize(field.fields));
          }
        } else {
          _fields.addAll(serialize(field.fields));
        }
      } else if (field is FixedArray) {
        _fields.add(Text('${field.id} ${field.title}'));
        _fields.addAll(serialize(field.fields));
      } else {
        if (field.dependencyConditions != null && field.dependencyParentPath != null) {
          final parentValue = getFormDataByPath(formData, field.dependencyParentPath!);
          if (field.dependencyConditions!.contains(parentValue)) {
            _fields.add(Text(field.id));
          }
        } else {
          _fields.add(Text(field.id));
        }
      }
    }
    return _fields;
  }
}
